// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/features/Auth/services/auth_service.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/custom_product_grid_admin.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/custom_app_bar.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/custom_catagery.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/custom_search_bar.dart';
import 'package:my_firebase_app/features/admin/service/product_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return BlocProvider(
      create: (_) => ProductCubit(ProductService())..fetchProducts(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Admin Dashboard'),
        body: Column(
          children: [
            CustomSearchBar(
              actionButton: Container(
                width: 51,
                height: 51,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.addProduct,
                    );
                    if (result == true) {
                      context.read<ProductCubit>().fetchProducts();
                    }
                  },
                  icon: Icon(Icons.add_ic_call, color: AppColors.bg),
                  iconSize: 30,
                ),
              ),
            ), // اربطها بالكيبوت
            SizedBox(height: 6),
            CustomCategory(),
            ProductsGridAdmin(),
          ],
        ),
      ),
    );
  }
}
