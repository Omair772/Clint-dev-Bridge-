import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/openai_service.dart';
import '../auth/register_screen.dart';
import '../home/client_dashboard.dart';

class AIResultScreen extends StatefulWidget {
  final String idea;
  const AIResultScreen({super.key, required this.idea});
  @override
  State<AIResultScreen> createState() => _AIResultScreenState();
}

class _AIResultScreenState extends State<AIResultScreen> {
  String aiResponse = "جاري التحليل...";
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    final response = await OpenAIService.analyzeProject(widget.idea);
    if (mounted) setState(() => aiResponse = response);
  }

  Future<void> _saveProject() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showDialog(context: context, builder: (_) => AlertDialog(title: const Text("يجب تسجيل الدخول"), content: const Text("لحفظ مشروعك يرجى التسجيل"), actions: [TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text("تسجيل"))]));
      return;
    }
    setState(() => isSaving = true);
    await FirebaseFirestore.instance.collection('projects').add({
      'userId': user.uid,
      'description': widget.idea,
      'ai_analysis': aiResponse,
      'status': 'Pending_Admin',
      'createdAt': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const ClientDashboard()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("نتائج التحليل")),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20)), child: Text(aiResponse, style: const TextStyle(color: Colors.white, height: 1.6))),
        const SizedBox(height: 30),
        ElevatedButton(onPressed: isSaving ? null : _saveProject, child: isSaving ? const CircularProgressIndicator() : const Text("إرسال للإدارة للتسعير")),
      ])),
    );
  }
}