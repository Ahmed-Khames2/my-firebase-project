// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_state.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/product_card.dart';

class ProductsGridAdmin extends StatelessWidget {
  const ProductsGridAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) return Center(child: Text(state.error));

          final products = state is ProductLoaded ? state.filteredProducts : [];
          if (products.isEmpty) return Center(child: Text("No products found"));

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ProductCard(
                product: p,
                onTap: () => showProductOptions(context, p),
              );
            },
          );
        },
      ),
    );
  }

  void showProductOptions(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(product.name),
            content: const Text("Choose an action"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.editProduct,
                    arguments: product,
                  );
                  // مش محتاج fetchProducts() لأن عندنا Stream مباشر
                },
                child: const Text("✏️ Edit"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await context.read<ProductCubit>().deleteProduct(product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("🗑️ Product deleted")),
                  );
                  // Stream مباشر، مش محتاج fetchProducts()
                },
                child: const Text(
                  "🗑️ Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
