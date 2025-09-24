import 'package:flutter/material.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/custom_catagery.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/custom_search_bar.dart';
import 'package:my_firebase_app/features/products/presentation/widgets/custom_app_bar.dart';
import 'package:my_firebase_app/features/products/presentation/widgets/custom_product_grid.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: AppColors.bg,
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
                onPressed: () {},
                icon: Icon(Icons.add_ic_call, color: AppColors.bg),
                iconSize: 30,
              ),
            ),
          ),
          SizedBox(height: 6),
          CustomCategory(),
          ProductsGrid(
            onTap: (ProductModel product) {
              Navigator.pushNamed(
                context,
                AppRoutes.productDetails,
                arguments: product,
              );
            },
          ),
        ],
      ),
    );
  }
}
