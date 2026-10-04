import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  void _submitPrice(BuildContext context, String projectId) {
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تقديم عرض سعر"),
        content: TextField(
          controller: priceController,
          decoration: const InputDecoration(labelText: "السعر المقترح"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (priceController.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('projects')
                    .doc(projectId)
                    .update({
                  'offeredPrice': priceController.text,
                  'status': 'Awaiting_Payment',
                });
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("إرسال للعميل"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل المشروع"),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: () => _submitPrice(context, widget.projectId),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.projectId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                data['title'] ?? 'بدون عنوان',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("الميزانية الأصلية: \$${data['budget'] ?? '0'}"),
              Text("السعر المقترح: \$${data['offeredPrice'] ?? 'لم يُحدد بعد'}"),
              Text("الحالة: ${data['status']}"),
              const SizedBox(height: 20),
              const Text("الوصف:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data['description'] ?? 'لا يوجد وصف'),
            ],
          );
        },
      ),
    );
  }
}