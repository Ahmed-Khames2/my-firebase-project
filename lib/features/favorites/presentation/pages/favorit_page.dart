import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:my_firebase_app/features/products/presentation/widgets/product_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: BlocBuilder<FavoriteCubit, List<ProductModel>>(
        builder: (context, favProducts) {
          if (favProducts.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .69,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favProducts.length,
            itemBuilder: (context, index) {
              final product = favProducts[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetails,
                    arguments: product,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
