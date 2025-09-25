import 'package:flutter/material.dart';
import 'package:my_firebase_app/features/products/presentation/widgets/add_to_cart_button.dart';
import 'package:my_firebase_app/features/products/presentation/widgets/custom_app_bar_details_page.dart';
import '../../../core/models/product_model.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/styles.dart';
import 'widgets/product_slider.dart';
import 'widgets/product_price.dart';
import 'widgets/product_colors.dart';
import 'widgets/product_sizes.dart';
import 'widgets/product_reviews.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedImage = 0;
  String? selectedColor;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: CartAppBar(text: product.name),
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼️ السلايدر
            ProductSlider(
              images: product.images,
              selectedImage: selectedImage,
              onPageChanged: (index) {
                setState(() => selectedImage = index);
              },
              product: product,
            ),
            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: AppStyles.header1.copyWith(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ProductPrice(
              price: product.price,
              discountPrice: product.discountPrice,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(product.category, style: AppStyles.body1Regular),
                const Spacer(),
                const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(product.rating, style: AppStyles.body1Regular),
              ],
            ),
            const SizedBox(height: 16),

            /// الوصف
            Text("Description", style: AppStyles.header1),
            const SizedBox(height: 8),
            Text(
              product.description.isNotEmpty
                  ? product.description
                  : "No description available",
              style: AppStyles.body1Regular.copyWith(height: 1.6),
            ),
            const SizedBox(height: 20),

            /// الألوان
            if (product.colors.isNotEmpty)
              ProductColors(
                colors: product.colors,
                selectedColor: selectedColor,
                onSelect: (color) {
                  setState(() => selectedColor = color);
                },
              ),

            /// المقاسات
            if (product.sizes.isNotEmpty)
              ProductSizes(
                sizes: product.sizes,
                selectedSize: selectedSize,
                onSelect: (size) {
                  setState(() => selectedSize = size);
                },
              ),

            /// المراجعات
            if (product.reviewsCount.isNotEmpty)
              ProductReviews(reviews: product.reviewsCount),
          ],
        ),
      ),

      /// 🛒 زر أسفل الشاشة
      bottomNavigationBar: AddToCartButton(
        product: product,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ),
    );
  }
}
