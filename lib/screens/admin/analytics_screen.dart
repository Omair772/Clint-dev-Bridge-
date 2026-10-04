import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('projects').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          // حساب الإيرادات الحقيقية من الميزانيات
          double totalRevenue = 0.0;
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            totalRevenue += (data['budget'] is num) ? (data['budget'] as num).toDouble() : 0.0;
          }

          int usersCount = 0; // سنحتاج لجلبها بشكل منفصل أو عبر FutureBuilder

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // بطاقة الإيرادات (المربوطة بالمشاريع)
                _card("Total Revenue", "\$${totalRevenue.toStringAsFixed(0)}", Icons.attach_money, Colors.purple),
                const SizedBox(height: 20),
                // بطاقة المشاريع
                _card("Total Projects", "${snapshot.data!.docs.length}", Icons.work, Colors.green),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}