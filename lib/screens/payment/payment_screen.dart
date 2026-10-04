import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/payment_service.dart';
import 'payment_success.dart';
import 'payment_failed.dart';

class PaymentScreen extends StatefulWidget {
  // يمكن تمرير هذه القيم من الشاشة السابقة (شاشة الذكاء الاصطناعي)
  final String projectTitle;
  final String amount;

  const PaymentScreen({
    super.key,
    this.projectTitle = "تطوير النظام التقني",
    this.amount = "225", // كمثال: 225 دولار (العربون)
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;

  Future<void> _processPayment() async {
    setState(() => isLoading = true);

    // استدعاء خدمة Stripe التي قمت ببرمجتها
    final bool isSuccess = await PaymentService.makePayment(amount: widget.amount);

    if (!mounted) return;
    setState(() => isLoading = false);

    if (isSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PaymentSuccess()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaymentFailed()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text("الدفع الآمن", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بطاقة الحماية والثقة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff10B981), Color(0xff059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(color: const Color(0xff10B981).withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_rounded, color: Colors.white, size: 48),
                    SizedBox(height: 20),
                    Text(
                      "دفع مشفر ومحمي",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "جميع معاملاتك المالية مشفرة بالكامل بتقنية 256-bit ولا نشارك بيانات بطاقتك مع أي طرف.",
                      style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // ملخص الفاتورة
              Text(
                "ملخص المشروع",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.lightTextPrimary),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow("اسم المشروع", widget.projectTitle, isDark),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
                    _buildSummaryRow("التكلفة الإجمالية (التقديرية)", "\$4,500", isDark),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
                    _buildSummaryRow("الدفعة الأولى المطلوبة (5%)", "\$${widget.amount}", isDark, isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // زر الدفع
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _processPayment,
                  icon: isLoading ? const SizedBox() : const Icon(Icons.lock_outline),
                  label: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("ادفع \$${widget.amount} الآن", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security, size: 16, color: isDark ? Colors.white54 : Colors.black45),
                    const SizedBox(width: 8),
                    Text("مدعوم بواسطة منصة Stripe العالمية", style: TextStyle(color: isDark ? Colors.white54 : Colors.black45)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, bool isDark, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDark ? (isTotal ? Colors.white : Colors.white70) : (isTotal ? Colors.black : Colors.black54),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppColors.primary : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}