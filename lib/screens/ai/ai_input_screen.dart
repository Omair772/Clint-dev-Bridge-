import 'package:flutter/material.dart';
import 'ai_result_screen.dart';

class AIInputScreen extends StatefulWidget {
  const AIInputScreen({super.key});
  @override
  State<AIInputScreen> createState() => _AIInputScreenState();
}

class _AIInputScreenState extends State<AIInputScreen> {
  final ideaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("تحليل المشروع الذكي"), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: ideaController,
              maxLines: 6,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "اكتب فكرة مشروعك بالتفصيل هنا...",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true, fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  if (ideaController.text.isNotEmpty) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AIResultScreen(idea: ideaController.text)));
                  }
                },
                child: const Text("ابدأ التحليل الذكي", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}