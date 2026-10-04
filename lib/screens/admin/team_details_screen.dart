import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String teamId;
  final String teamName;

  const TeamDetailsScreen({super.key, required this.teamId, required this.teamName});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  // دالة حذف عضو من الفريق
  Future<void> _removeMember(String memberId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(memberId).update({
        'teamId': FieldValue.delete(),
      });
      await FirebaseFirestore.instance.collection('teams').doc(widget.teamId).update({
        'membersCount': FieldValue.increment(-1),
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم حذف العضو بنجاح")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: $e")));
    }
  }

  // دالة إضافة عضو جديد للفريق
  void _showAddMemberDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة عضو للفريق"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "اسم العضو")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "البريد الإلكتروني")),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: "رقم الهاتف")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () async {
              String email = emailController.text.trim();
              if (email.isNotEmpty) {
                // البحث عن المستخدم في قاعدة البيانات
                final userQuery = await FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: email)
                    .get();

                if (userQuery.docs.isNotEmpty) {
                  // تحديث بيانات المستخدم (الاسم، الهاتف، والفريق)
                  await userQuery.docs.first.reference.update({
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'teamId': widget.teamId,
                  });
                  // تحديث عداد الفريق
                  await FirebaseFirestore.instance.collection('teams').doc(widget.teamId).update({
                    'membersCount': FieldValue.increment(1),
                  });
                  if (context.mounted) Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لم يتم العثور على مستخدم بهذا البريد")));
                }
              }
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }

  // دالة فتح نافذة تعديل بيانات العضو
  void _showEditDialog(String memberId, Map<String, dynamic> currentData) async {
    final TextEditingController nameController = TextEditingController(text: currentData['name']);
    final TextEditingController roleController = TextEditingController(text: currentData['role'] ?? '');

    final teamsSnapshot = await FirebaseFirestore.instance.collection('teams').get();
    String selectedTeamId = currentData['teamId'] ?? widget.teamId;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("تعديل بيانات العضو"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "الاسم")),
              TextField(controller: roleController, decoration: const InputDecoration(labelText: "الدور")),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedTeamId,
                decoration: const InputDecoration(labelText: "نقل إلى فريق"),
                items: teamsSnapshot.docs.map((team) {
                  return DropdownMenuItem(value: team.id, child: Text(team['name']));
                }).toList(),
                onChanged: (value) => setDialogState(() => selectedTeamId = value!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').doc(memberId).update({
                  'name': nameController.text,
                  'role': roleController.text,
                  'teamId': selectedTeamId,
                });
                if (mounted) Navigator.pop(context);
              },
              child: const Text("حفظ"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.teamName)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('teamId', isEqualTo: widget.teamId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.isEmpty) return const Center(child: Text("لا يوجد أعضاء في هذا الفريق"));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final member = snapshot.data!.docs[index];
              final data = member.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: CircleAvatar(child: Text(data['name']?[0] ?? '?')),
                  title: Text(data['name'] ?? 'بدون اسم'),
                  subtitle: Text(data['role'] ?? 'عضو'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(member.id, data),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeMember(member.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMemberDialog(context),
        label: const Text("إضافة عضو"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}