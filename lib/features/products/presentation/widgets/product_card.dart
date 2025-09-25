import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_firebase_app/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:my_firebase_app/core/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة مع أيقونة الفاف
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child:
                        product.images.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: product.images.first,
                              fit: BoxFit.cover,
                              placeholder:
                                  (_, __) => Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                              errorWidget:
                                  (_, __, ___) => Image.asset(
                                    'assets/images/scholar.png',
                                    fit: BoxFit.cover,
                                  ),
                            )
                            : Image.asset(
                              'assets/images/scholar.png',
                              fit: BoxFit.cover,
                            ),
                  ),
                ),

                // زر الفاف فوق الصورة
                Positioned(
                  top: 8,
                  right: 8,
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
              ],
            ),

            // الاسم والسعر
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.productTitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                children: [
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: AppStyles.productPrice,
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.isNotEmpty ? product.rating : '0.0',
                    style: AppStyles.body1Regular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
