import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: AppStyles.body1Medium),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ صور المنتج (سلايدر)
            SizedBox(
              height: 280,
              child: PageView.builder(
                itemCount: product.images.isNotEmpty ? product.images.length : 1,
                itemBuilder: (context, index) {
                  final imageUrl = product.images.isNotEmpty
                      ? product.images[index]
                      : "https://via.placeholder.com/300";
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 📝 اسم المنتج
            Text(
              product.name,
              style: AppStyles.body1SemiBold.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),

            // 💰 السعر والخصم
            Row(
              children: [
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: AppStyles.body1SemiBold.copyWith(
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                ),
                if (product.discountPrice != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    "\$${product.discountPrice!.toStringAsFixed(2)}",
                    style: AppStyles.body1Regular.copyWith(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // 🖊️ الوصف
            Text(
              product.description.isNotEmpty
                  ? product.description
                  : "No description available",
              style: AppStyles.body1Regular.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // 🎨 الألوان
            if (product.colors.isNotEmpty) ...[
              Text("Available Colors:", style: AppStyles.body1SemiBold),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: product.colors.map((color) {
                  return CircleAvatar(
                    radius: 16,
                    backgroundColor: _getColorFromName(color),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // 📏 المقاسات
            if (product.sizes.isNotEmpty) ...[
              Text("Available Sizes:", style: AppStyles.body1SemiBold),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: product.sizes.map((size) {
                  return Chip(
                    label: Text(size),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    labelStyle:
                        AppStyles.body2Medium.copyWith(color: AppColors.primary),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // ⭐ التقييم
            if (product.rating.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(product.rating,
                      style: AppStyles.body1Regular.copyWith(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // 💬 المراجعات
            if (product.reviews.isNotEmpty) ...[
              Text("Customer Reviews:", style: AppStyles.body1SemiBold),
              const SizedBox(height: 8),
              Column(
                children: product.reviews.map((review) {
                  return ListTile(
                    leading: const Icon(Icons.person, color: AppColors.primary),
                    title: Text(review, style: AppStyles.body2Regular),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // 🛒 زر إضافة للسلة
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: Add to cart logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${product.name} added to cart")),
                  );
                },
                child: Text(
                  "Add to Cart",
                  style: AppStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper لتحويل اسم اللون لـ Color (بسيط)
  Color _getColorFromName(String color) {
    switch (color.toLowerCase()) {
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
      case "black":
        return Colors.black;
      case "white":
        return Colors.white;
      default:
        return AppColors.primary;
    }
  }
}
