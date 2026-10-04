import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';

class ReviewTasksScreen extends StatelessWidget {
  const ReviewTasksScreen({super.key});

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    await FirebaseFirestore.instance.collection('projects').doc(taskId).update({
      'status': newStatus,
      'reviewedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("مراجعة المهام المسلمة")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .where('status', isEqualTo: 'Pending_Review') // جلب المهام المسلمة فقط
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.isEmpty) return const Center(child: Text("لا توجد مهام بانتظار المراجعة"));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final task = snapshot.data!.docs[index];
              final data = task.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(data['title'] ?? 'بدون عنوان'),
                  subtitle: const Text("تم تسليم العمل بانتظار المراجعة"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => _updateTaskStatus(task.id, 'Completed'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _updateTaskStatus(task.id, 'In_Progress'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}