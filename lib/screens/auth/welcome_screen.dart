import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // خلفية داكنة فخمة
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Spacer(),

              // الأيقونة بشكل فخم
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF6366F1), size: 60),
              ),

              const SizedBox(height: 40),

              const Text(
                "Build Your Dream\nWith AI",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
              ),

              const SizedBox(height: 20),

              const Text(
                "منصة احترافية لبناء التطبيقات والأنظمة الذكية.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white60),
              ),
              const Text(
                "تم تصميم التطبيق بواسطة م/عمير صادق الدعداع .",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.purple),
              ),
              const Spacer(),

              // زر الدخول
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: const Text("تسجيل الدخول", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 18),

              // زر إنشاء حساب
              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF6366F1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Text("إنشاء حساب جديد", style: TextStyle(fontSize: 18, color: Color(0xFF6366F1))),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}