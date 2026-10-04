import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'app_state.dart';
import 'core/theme/app_theme.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';        // لوحة تحكم الموظف
import 'screens/home/client_dashboard.dart';   // لوحة تحكم العميل
import 'screens/admin/admin_dashboard.dart';   // لوحة تحكم الإدارة

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClientDevBridgeApp());
}

class ClientDevBridgeApp extends StatelessWidget {
  const ClientDevBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Client Dev Bridge',
              locale: locale,
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              home: const AuthGate(),
            );
          },
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // إذا لم يسجل الدخول، اذهب لشاشة البداية
        if (!snapshot.hasData) {
          return const SplashScreen();
        }

        // إذا سجل دخول، تحقق من الصلاحيات (Role)
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // تحويل البيانات لـ Map لتجنب الخطأ
            final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
            final role = userData?['role'] ?? 'Client';

            // 3. التوجيه الذكي بناءً على الصلاحية
            if (role == 'Admin') {
              return const AdminDashboard();
            } else if (role == 'Employee') {
              return const HomeScreen(); // لوحة تحكم الموظف
            } else {
              return const ClientDashboard(); // لوحة تحكم العميل
            }
          },
        );
      },
    );
  }
}