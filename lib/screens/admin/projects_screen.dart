import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'project_details_screen.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تم إضافة 'Pending_Admin' لتطابق ما هو موجود في Firestore
    final List<String> statuses = [
      'Pending_Admin',
      'In Progress',
      'Completed',
      'Cancelled'
    ];

    return DefaultTabController(
      length: statuses.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة المشاريع"),
          bottom: TabBar(
            isScrollable: true,
            // تحسين عرض التاب (إزالة الشرطة السفلية)
            tabs: statuses.map((status) => Tab(text: status.replaceAll('_', ' '))).toList(),
          ),
        ),
        body: TabBarView(
          children: statuses.map((status) => _buildProjectList(status)).toList(),
        ),
      ),
    );
  }

  Widget _buildProjectList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('projects').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        // فلترة المشاريع بناءً على الحالة
        final filteredDocs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final docStatus = (data['status'] ?? '').toString().trim();
          return docStatus == status.trim();
        }).toList();

        if (filteredDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("لا توجد مشاريع في حالة: ${status.replaceAll('_', ' ')}"),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    final querySnapshot = await FirebaseFirestore.instance.collection('projects').get();
                    debugPrint("عدد المشاريع الكلي: ${querySnapshot.docs.length}");
                    for (var doc in querySnapshot.docs) {
                      debugPrint("المشروع: ${doc.data()}");
                    }
                  },
                  child: const Text("تحقق من البيانات في الكونسول"),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final doc = filteredDocs[index];
            final data = doc.data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: ListTile(
                title: Text(data['title'] ?? 'بدون عنوان', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("الحالة: ${data['status']?.toString().replaceAll('_', ' ')}\nالميزانية: \$${data['budget'] ?? '0'}"),
                isThreeLine: true,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProjectDetailsScreen(projectId: doc.id)),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}