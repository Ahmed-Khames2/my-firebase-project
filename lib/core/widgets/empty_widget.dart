
import 'package:flutter/material.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.imagePath,
  });

  final String text1;
  final String text2;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 80, width: 80),
          const SizedBox(height: 22),
          Text(
            text1,
            style: AppStyles.header3.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              text2,
              style: AppStyles.body1Regular.copyWith(
                color: AppColors.greyMedium,
              ),
              textAlign: TextAlign.center, // لو النص طويل يتظبط
            ),
          ),
        ],
      ),
    );
  }
}
