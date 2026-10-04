import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Future<User?> register({

    required String email,
    required String password,

  }) async {

    try {

      final credential =
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;

    } catch (e) {

      return null;
    }
  }

  Future<User?> login({

    required String email,
    required String password,

  }) async {

    try {

      final credential =
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;

    } catch (e) {

      return null;
    }
  }

  Future<void> logout() async {

    await _auth.signOut();
  }
}