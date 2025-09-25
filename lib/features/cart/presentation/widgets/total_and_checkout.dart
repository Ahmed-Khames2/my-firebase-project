
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:my_firebase_app/features/cart/presentation/cubit/cart_cubit.dart';

class TotalAndCheckout extends StatelessWidget {
  const TotalAndCheckout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Total:',
                style: AppStyles.header4Medium.copyWith(
                  fontSize: 18,
                  color: AppColors.greyDark,
                ),
              ),
              const Spacer(),
              Text(
                "\$${context.read<CartCubit>().total.toStringAsFixed(2)}",
                style: AppStyles.header1.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // TODO: Navigate to checkout page
              },
              child: Text(
                "Proceed to Checkout",
                style: AppStyles.header4Medium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
