import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_color.dart';

class ProductSlider extends StatelessWidget {
  final List<String> images;
  final int selectedImage;
  final ValueChanged<int> onPageChanged;
    final ProductModel product; // ✅ ضفنا المنتج


  const ProductSlider({
    super.key,
    required this.images,
    required this.selectedImage,
    required this.onPageChanged, required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            onPageChanged: onPageChanged,
            itemCount: images.isNotEmpty ? images.length : 1,
            itemBuilder: (context, index) {
              final imageUrl =
                  images.isNotEmpty ? images[index] : "https://via.placeholder.com/300";
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.error, size: 50, color: Colors.red),
                ),
              );
            },
          ),
            /// ✅ أيقونة المفضلة فوق الصور
          Positioned(
            top: 12,
            right: 12,
            child: BlocBuilder<FavoriteCubit, List<ProductModel>>(
              builder: (context, favorites) {
                final isFav = favorites.any((p) => p.id == product.id);

                return GestureDetector(
                  onTap: () {
                    context.read<FavoriteCubit>().toggleFavorite(product);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.black54,
                    ),
                  ),
                );
              },
            ),
          ),
          if (images.length > 1)
            Positioned(
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selectedImage == index ? 14 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selectedImage == index ? AppColors.primary : Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
