import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_firebase_app/consatnt.dart';
import 'package:my_firebase_app/widgets/custom_button.dart';
import 'package:my_firebase_app/widgets/custom_text_field.dart';
import 'package:my_firebase_app/services/auth_service.dart'; // <-- هنا ضفنا الـ Service

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  static String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  AuthService authService = AuthService(); // instance of AuthService

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
                      'REGISTER',
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
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: 'Password',
                ),
                SizedBox(height: 20),
                CustomButon(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      await authService.registerUser(
                        context: context,
                        email: email!,
                        password: password!,
                      );

                      setState(() => isLoading = false);
                    }
                  },
                  text: 'REGISTER',
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '  Login',
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
