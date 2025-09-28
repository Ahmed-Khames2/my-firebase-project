import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:my_firebase_app/features/address/presentation/cubit/addrescubit.dart';
import 'package:my_firebase_app/features/address/presentation/pages/address_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_firebase_app/features/address/service/address_service.dart';
import 'package:my_firebase_app/features/checkout/cubit/checkout_cubit.dart';
import 'package:my_firebase_app/features/checkout/presentation/checkout_page.dart';

class CheckoutButtom extends StatelessWidget {
  const CheckoutButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {

         
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (_) => CheckoutCubit(),
                    child: const CheckoutPage(),
                  ),
            ),
          );
        },
        child: Text("Checkout", style: AppStyles.button),
      ),
    );
  }
}
