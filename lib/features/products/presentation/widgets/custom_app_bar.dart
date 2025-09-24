import 'package:flutter/material.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Discover', style: AppStyles.header1),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: AppColors.primary),
          ),
        ],
      ),
      backgroundColor: AppColors.bg,
      // centerTitle: true,
      elevation: 0,
    );
  }

  /// ✅ لازم ترجع حجم الأب بار (الارتفاع)
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
