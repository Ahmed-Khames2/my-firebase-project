import 'package:flutter/material.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBar({
    super.key,
    required this.text,
    this.onBack, // ✅ اختياري
    this.onNotification,
  });

  final String text;
  final VoidCallback? onBack; // زر الرجوع
  final VoidCallback? onNotification; // زر الإشعارات

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(text, style: AppStyles.header1),
      backgroundColor: AppColors.bg,
      centerTitle: true,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(color: AppColors.greyLighter, width: 0.5),
      ),
      leading: IconButton(
        onPressed: onBack ?? () => Navigator.pop(context), // ✅ افتراضي pop
        icon: Icon(Icons.arrow_back, color: AppColors.primary),
      ),
      actions: [
        IconButton(
          onPressed: onNotification ?? () {}, // ✅ callback اختياري
          icon: Icon(Icons.notifications_outlined, color: AppColors.primary),
        ),
      ],
    );
  }

  /// ✅ لازم ترجع حجم الأب بار (الارتفاع)
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
