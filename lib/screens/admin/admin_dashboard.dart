import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../auth/welcome_screen.dart';
import 'users_screen.dart';
import 'projects_screen.dart';
import 'teams_screen.dart';
import 'analytics_screen.dart';
import 'review_tasks_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("لوحة التحكم", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('projects').snapshots(),
            builder: (context, snapshot) {
              int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_active_rounded),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectsScreen())),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8, top: 8,
                      child: CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text("$count", style: TextStyle(fontSize: 8, color: Colors.white))),
                    ),
                ],
              );
            },
          ),
          IconButton(icon: const Icon(Icons.logout, color: Colors.redAccent), onPressed: _logout),
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الإحصائيات الحية (تم إضافة الفرق هنا)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('projects').snapshots(),
              builder: (context, projectSnap) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, userSnap) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('teams').snapshots(),
                      builder: (context, teamSnap) {
                        return Column(
                          children: [
                            Row(children: [
                              Expanded(child: _buildStatCard("المشاريع", "${projectSnap.hasData ? projectSnap.data!.docs.length : 0}", Icons.work_rounded, const Color(0xff10B981), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectsScreen())))),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard("المستخدمين", "${userSnap.hasData ? userSnap.data!.docs.length : 0}", Icons.people_alt_rounded, const Color(0xff3B82F6), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UsersScreen())))),
                            ]),
                            const SizedBox(height: 16),
                            Row(children: [
                              Expanded(child: _buildStatCard("الفرق", "${teamSnap.hasData ? teamSnap.data!.docs.length : 0}", Icons.groups_rounded, const Color(0xffF59E0B), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamsScreen())))),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard("تحليلات", "...", Icons.analytics_rounded, const Color(0xff8B5CF6), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen())))),
                            ]),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            Text("إجراءات سريعة", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 16),
            _buildQuickActionTile("إدارة المستخدمين", "تعديل الصلاحيات والحظر", Icons.manage_accounts_rounded, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UsersScreen()))),
            _buildQuickActionTile("مراجعة المهام", "قبول أو رفض الأعمال المنجزة", Icons.rate_review_rounded, Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewTasksScreen()))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
          Text(title, style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.black54)),
        ]),
      ),
    );
  }

  Widget _buildQuickActionTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}