import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../app_state.dart';
import '../../core/constants/app_colors.dart';
import '../auth/welcome_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  bool isLoading = true;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    isDarkMode = themeNotifier.value == ThemeMode.dark;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data != null && mounted) {
        setState(() {
          userName = data['name'] ?? 'مستخدم جديد';
          userEmail = data['email'] ?? user.email ?? '';
          userPhone = data['phone'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // رأس الملف الشخصي
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? AppColors.darkCard : Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                  const SizedBox(height: 4),
                  Text(userEmail, style: TextStyle(fontSize: 16, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                      if (updated == true) _loadUserData(); // تحديث البيانات إذا تم التعديل
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text("تعديل البيانات"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(160, 45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // قائمة الإعدادات
            _buildSettingsSection(
              isDark,
              "إعدادات التطبيق",
              [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("الوضع الليلي", style: TextStyle(fontWeight: FontWeight.bold)),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.dark_mode_outlined, color: Colors.indigo),
                  ),
                  value: isDarkMode,
                  activeColor: AppColors.primary,
                  onChanged: (value) async {
                    setState(() => isDarkMode = value);
                    await AppState.changeTheme(value);
                  },
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.language_outlined, color: Colors.teal),
                  ),
                  title: const Text("لغة التطبيق", style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: DropdownButton<String>(
                    value: localeNotifier.value.languageCode,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: const [
                      DropdownMenuItem(value: 'ar', child: Text('العربية', style: TextStyle(fontWeight: FontWeight.bold))),
                      DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    onChanged: (value) async {
                      if (value != null) await AppState.changeLanguage(value);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // زر تسجيل الخروج
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text("تسجيل الخروج", style: TextStyle(color: AppColors.error, fontSize: 16, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(bool isDark, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.lightTextPrimary)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}