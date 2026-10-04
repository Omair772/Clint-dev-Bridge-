import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  // دالة لتغيير الصلاحيات أو الحظر
  Future<void> _updateUserStatus(String userId, Map<String, dynamic> updates) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update(updates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إدارة المستخدمين")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final userDoc = snapshot.data!.docs[index];
              final data = userDoc.data() as Map<String, dynamic>;
              bool isBlocked = data['isBlocked'] ?? false;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isBlocked ? Colors.red : Colors.blue,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(data['name'] ?? 'بدون اسم'),
                  subtitle: Text("الدور: ${data['role'] ?? 'User'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر الحظر / فك الحظر
                      IconButton(
                        icon: Icon(isBlocked ? Icons.lock_open : Icons.lock,
                            color: isBlocked ? Colors.green : Colors.orange),
                        onPressed: () => _updateUserStatus(userDoc.id, {'isBlocked': !isBlocked}),
                      ),
                      // زر ترقية الصلاحيات
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.admin_panel_settings),
                        onSelected: (newRole) => _updateUserStatus(userDoc.id, {'role': newRole}),
                        itemBuilder: (context) => ['Admin', 'Employee', 'User']
                            .map((role) => PopupMenuItem(value: role, child: Text(role)))
                            .toList(),
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