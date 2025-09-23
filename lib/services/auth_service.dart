import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase_app/helper/show_snack_bar.dart';
import 'package:my_firebase_app/pages/chat_page.dart';
import 'package:my_firebase_app/pages/login_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // تسجيل خروج
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.id, // الصفحة اللي هيروح لها بعد تسجيل الخروج
      (Route<dynamic> route) => false, // امسح كل الصفحات القديمة
    );
  }

  // تسجيل دخول
  Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user;

      if (user != null && user.emailVerified) {
        // لو الإيميل متحقق، نروح للصفحة الرئيسية
        Navigator.pushReplacementNamed(context, ChatPage.id, arguments: email);
      } else {
        // لو الإيميل مش متحقق، نعرض رسالة ونخرج
        showSnackBar(context, 'Please verify your email first.');
        await _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Login error.');
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
    }
  }

  // تسجيل مستخدم جديد
  Future<void> registerUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();

      showSnackBar(context, 'Verification email sent! Check your inbox.');

      // وجهه لصفحة Login بدل ChatPage
      Navigator.pushReplacementNamed(context, LoginPage.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'Email already in use.');
      } else {
        showSnackBar(context, e.message ?? 'Registration error.');
      }
    }
  }
  
   // ---- Reset Password ----
  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackBar(context, 'Reset password email sent! Check your inbox.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Error sending reset email.');
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
    }
  }
}
