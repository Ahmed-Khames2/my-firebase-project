import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';

class CustomSearchBar extends StatelessWidget {
  final Widget actionButton; // هنا الأيقونة أو الزر الإضافي اللي تحطه

  const CustomSearchBar({
    super.key,
    required this.actionButton, // لازم المستخدم يمررها
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                context.read<ProductCubit>().searchProducts(value);
              },
              decoration: InputDecoration(
                hintText: 'Search For Products...',
                hintStyle: AppStyles.body1Regular.copyWith(
                  color: AppColors.greyDark,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.greyLighter),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.greyLighter,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.greyLighter,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.greyDark, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          actionButton, // هنا الزر اللي المستخدم يمرره
        ],
      ),
    );
  }
}
