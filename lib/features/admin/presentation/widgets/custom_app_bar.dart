import 'package:flutter/material.dart';
import 'package:my_firebase_app/features/Auth/services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            authService.signOut(context);
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
