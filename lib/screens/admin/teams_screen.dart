import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'team_details_screen.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  // 1. دالة حذف الفريق
  Future<void> _deleteTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).delete();
  }

  // 2. دالة فتح نافذة تعديل الفريق
  void _showEditTeamDialog(BuildContext context, String teamId, Map<String, dynamic> data) {
    final TextEditingController nameController = TextEditingController(text: data['name']);
    final TextEditingController descController = TextEditingController(text: data['description'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تعديل بيانات الفريق"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "اسم الفريق")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "الوصف")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
                'name': nameController.text,
                'description': descController.text,
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  // 3. دالة فتح نافذة إضافة فريق جديد
  void _showAddTeamDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة فريق جديد"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "اسم الفريق")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "الوصف")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('teams').add({
                  'name': nameController.text,
                  'description': descController.text,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إدارة الفرق التقنية")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('teams').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد فرق مضافة. اضغط 'فريق جديد' للبدء"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final team = snapshot.data!.docs[index];
              final data = team.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(data['name'] ?? 'بدون اسم'),
                  subtitle: Text(data['description'] ?? ''),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => TeamDetailsScreen(teamId: team.id, teamName: data['name']),
                  )),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditTeamDialog(context, team.id, data)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteTeam(team.id)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTeamDialog(context),
        label: const Text("فريق جديد"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}