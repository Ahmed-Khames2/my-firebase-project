import 'package:flutter/material.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';

class CustomIcone extends StatelessWidget {
  const CustomIcone({
    super.key,
    required this.icone,
    required this.onPressed,
    required item,
  });

  final IconData icone;
  final VoidCallback onPressed; // هنا الفنكشن كـ variable

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.greyLighter, width: 1.5),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed, // variable من برّه
        icon: Icon(icone, size: 22, color: AppColors.primary),
      ),
    );
  }
}
