// import 'package:flutter/material.dart';
// import 'package:my_firebase_app/core/theme/app_color.dart';

// class CustomIconButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onPressed;
//   final Color? backgroundColor;
//   final Color? iconColor;
//   final double size;

//   const CustomIconButton({
//     super.key,
//     required this.icon,
//     required this.onPressed,
//     this.backgroundColor,
//     this.iconColor,
//     this.size = 51,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: backgroundColor ?? AppColors.primary,
//         border: Border.all(color: AppColors.primary, width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: IconButton(
//         onPressed: onPressed,
//         icon: Icon(icon, color: iconColor ?? AppColors.bg),
//         iconSize: 30,
//       ),
//     );
//   }
// }
