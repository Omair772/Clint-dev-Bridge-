import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PaymentFailed extends StatelessWidget {
  const PaymentFailed({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cancel_rounded, color: AppColors.error, size: 90),
              ),
              const SizedBox(height: 40),
              Text(
                "فشلت عملية الدفع ❌",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.lightTextPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                "حدث خطأ أثناء معالجة الدفع. يرجى التحقق من بيانات البطاقة أو الرصيد والمحاولة مرة أخرى.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.6, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("المحاولة مرة أخرى", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}