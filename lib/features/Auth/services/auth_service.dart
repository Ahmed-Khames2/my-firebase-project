import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase_app/core/helper/show_snack_bar.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل خروج
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login, // استخدم الروت المعرّف في ملف AppRoutes
      (Route<dynamic> route) => false, // امسح كل الصفحات القديمة
    );
  }

  // تسجيل دخول مع التحقق من الدور
  Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null && user.emailVerified) {
        // جلب بيانات المستخدم من Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        String role = userDoc['role'] ?? 'user';

        if (role == 'admin') {
          // لو الأدمن
          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        } else {
          // لو مستخدم عادي
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.productPage,
            arguments: email,
          );
        }
      } else {
        // لو الإيميل مش متحقق
        showSnackBar(context, 'Please verify your email first.');
        await _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Login error.');
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred: $e');
      print('Login error: $e');
    }
  }

  // تسجيل مستخدم جديد مع حفظ الاسم والصورة
  Future<void> registerUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    String? profileImageUrl,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'profileImageUrl': profileImageUrl ?? '',
          'role': 'user',
        });

        showSnackBar(context, 'Verification email sent! Check your inbox.');
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'Email already in use.');
      } else {
        showSnackBar(context, e.message ?? 'Registration error.');
      }
    } catch (e) {
      showSnackBar(context, 'Unexpected error: $e');
      print('Unexpected error: $e');
    }
  }

  // رفع صورة على Cloudinary
  // Future<String?> uploadImageToCloudinary(File file) async {
  //   try {
  //     String cloudName = 'drlr0etui';       // Cloud Name بتاعك
  //     String uploadPreset = 'ml_default';   // Upload Preset اللي عملتهللي عملته

  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
  //     );

  //     request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //     request.fields['upload_preset'] = uploadPreset;

  //     var response = await request.send();
  //     var resData = await http.Response.fromStream(response);
  //     var jsonData = json.decode(resData.body);

  //     return jsonData['secure_url']; // رابط الصورة النهائي
  //   } catch (e) {
  //     print('Cloudinary upload error: $e');
  //     return null;
  //   }
  // }

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
