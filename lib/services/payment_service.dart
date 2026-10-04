import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  // تذكر: هذه مفاتيح تجريبية (Test Keys).
  // في النسخة النهائية استخدم بيئة Cloud Functions لتأمين الـ Secret Key
  static String publishableKey = "pk_test_YOUR_PUBLISHABLE_KEY_HERE";
  static String secretKey = "sk_test_YOUR_SECRET_KEY_HERE";

  /// تهيئة Stripe عند بداية تشغيل التطبيق
  static Future<void> init() async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  /// إنشاء نية دفع (Payment Intent) مع Stripe
  static Future<Map<String, dynamic>?> createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "amount": calculateAmount(amount),
          "currency": currency,
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Error creating payment intent: $e");
      return null;
    }
  }

  /// عرض نافذة الدفع (Payment Sheet)
  static Future<bool> makePayment({required String amount}) async {
    try {
      // 1. إنشاء الـ Intent
      final paymentIntent = await createPaymentIntent(amount: amount, currency: "usd");
      if (paymentIntent == null) return false;

      // 2. تهيئة نافذة الدفع
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: "Client-Dev Bridge",
          paymentIntentClientSecret: paymentIntent["client_secret"],
          style: ThemeMode.dark,
        ),
      );

      // 3. عرض النافذة
      await Stripe.instance.presentPaymentSheet();
      return true; // تمت العملية بنجاح

    } on StripeException catch (e) {
      debugPrint("Stripe Error: ${e.error.localizedMessage}");
      return false;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }

  /// تحويل المبلغ إلى Cent (نظام Stripe يطلب المبلغ بالـ Cents)
  static String calculateAmount(String amount) {
    final doubleAmount = double.parse(amount) * 100;
    return doubleAmount.toInt().toString();
  }
}