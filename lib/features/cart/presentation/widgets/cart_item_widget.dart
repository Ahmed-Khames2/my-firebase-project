import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:my_firebase_app/features/cart/presentation/cubit/cart_cubit.dart';

class CartItemWidget extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;

  const CartItemWidget({
    super.key,
    required this.product,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(product.id + (selectedColor ?? '') + (selectedSize ?? '')),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      onDismissed: (_) {
        context.read<CartCubit>().removeFromCart(
          product.id,
          color: selectedColor,
          size: selectedSize,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${product.name} removed ❌")));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  product.images.isNotEmpty
                      ? Image.network(
                        product.images.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 40),
                      ),
            ),
            const SizedBox(width: 12),

            /// اسم وسعر + اللون والمقاس
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppStyles.productTitle.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "\$${(product.discountPrice ?? product.price).toStringAsFixed(2)}",
                    style: AppStyles.productPrice.copyWith(fontSize: 15),
                  ),
                  // if (selectedColor != null)
                  //   Text("Color: $selectedColor",
                  //       style: const TextStyle(fontSize: 13)),
                  // if (selectedSize != null)
                  //   Text("Size: $selectedSize",
                  //       style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),

            /// أزرار + / -
            Row(
              children: [
                IconButton(
                  onPressed:
                      () => context.read<CartCubit>().decreaseQuantity(
                        product.id,
                        color: selectedColor,
                        size: selectedSize,
                      ),
                  icon: const Icon(Icons.remove_circle_outline, size: 22),
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed:
                      () => context.read<CartCubit>().increaseQuantity(
                        product.id,
                        color: selectedColor,
                        size: selectedSize,
                      ),
                  icon: const Icon(Icons.add_circle_outline, size: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
