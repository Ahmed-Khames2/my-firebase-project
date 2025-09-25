import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_firebase_app/core/constant/consatnt.dart';
import 'package:my_firebase_app/core/helper/show_snack_bar.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/features/Auth/services/auth_service.dart';
import 'package:my_firebase_app/features/chat/presentation/widgets/custom_button.dart';
import 'package:my_firebase_app/features/chat/presentation/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String id = 'login page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  AuthService authService = AuthService();

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 75),
                Image.asset('assets/images/scholar.png', height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scholar Chat',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'pacifico',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 75),
                Row(
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomFormTextField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: 'Email',
                ),
                SizedBox(height: 10),
                CustomFormTextField(
                  obscureText: true,
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: 'Password',
                ),
                SizedBox(height: 20),
                // ---- Google Sign-In Button ----
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     foregroundColor: Colors.black,
                //   ),
                //   onPressed: () async {
                //     setState(() => isLoading = true);
                //     User? user = await authService.signInWithGoogle(context);
                //     setState(() => isLoading = false);

                //     if (user != null) {
                //       Navigator.pushNamed(
                //         context,
                //         ChatPage.id,
                //         arguments: user.email,
                //       );
                //     }
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset('assets/images/scholar.png', height: 24),
                //       SizedBox(width: 8),
                //       Text("Sign in with Google"),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10),
                // ---- Email/Password Login ----
                CustomButon(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      await authService.loginUser(
                        context: context,
                        email: email!,
                        password: password!,
                      );

                      setState(() => isLoading = false);
                    }
                  },
                  text: 'LOGIN',
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    if (email != null && email!.isNotEmpty) {
                      authService.resetPassword(
                        context: context,
                        email: email!,
                      );
                    } else {
                      showSnackBar(context, 'Please enter your email first.');
                    }
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'dont\'t have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: Text(
                        '  Register',
                        style: TextStyle(color: Color(0xffC7EDE6)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
