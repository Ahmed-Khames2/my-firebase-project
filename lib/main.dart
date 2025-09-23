import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/cubits/auth/auth_cubit.dart';
import 'package:my_firebase_app/features/admin/AdminDashboard.dart';
import 'package:my_firebase_app/pages/chat_page.dart';
import 'package:my_firebase_app/pages/login_page.dart';
import 'package:my_firebase_app/pages/resgister_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: const ScholarChat(),
    ),
  );
}

class ScholarChat extends StatelessWidget {
  const ScholarChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        ChatPage.id: (context) => ChatPage(),
        AdminDashboard.id: (context) => AdminDashboard(),
      },
      initialRoute: LoginPage.id,
    );
  }
}
