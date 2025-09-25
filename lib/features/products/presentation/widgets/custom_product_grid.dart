import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_state.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  final void Function(ProductModel product) onTap; // مطلوب وبيستقبل المنتج نفسه

  const ProductsGrid({super.key, required this.onTap});

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
              return ProductCard(product: p, onTap: () => onTap(p));
            },
          );
        },
      ),
    );
  }
}
