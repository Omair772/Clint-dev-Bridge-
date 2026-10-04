import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_screen.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

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
              // دائرة النجاح المتحركة/المضيئة
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.success.withOpacity(0.3), blurRadius: 40, spreadRadius: 10),
                  ],
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 90),
              ),
              const SizedBox(height: 40),
              Text(
                "عملية دفع ناجحة! 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.lightTextPrimary),
              ),
              const SizedBox(height: 16),
              Text(
                "تم استلام الدفعة الأولى واعتماد مشروعك بنجاح. سيقوم فريقنا بالتواصل معك قريباً للبدء في التنفيذ.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.6, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("العودة إلى الرئيسية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}