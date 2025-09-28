import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/core/widgets/empty_widget.dart';
import 'package:my_firebase_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:my_firebase_app/features/cart/presentation/widgets/CheckoutButtom.dart';
import 'package:my_firebase_app/features/cart/presentation/widgets/TotaPrice.dart';
import 'package:my_firebase_app/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:my_firebase_app/features/products/presentation/widgets/custom_app_bar_details_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartAppBar(text: "My Cart"),

      // appBar: AppBar(
      //   title: Text('My Cart'),
      // onBack: () {},
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.delete_forever, color: Colors.red),
      //     onPressed: () {
      //       context.read<CartCubit>().clearCart();
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text("Cart cleared 🗑️")),
      //       );
      //     },
      //   ),
      // ],
      // ),
      body: BlocBuilder<CartCubit, List<Map<String, dynamic>>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return EmptyWidget(
              imagePath: "assets/images/Cart-duotone.png",
              text1: "Your Cart Is Empty!",
              text2: "When you add products, they’ll appear here.",
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final product = item['product'] as ProductModel;
                    final quantity = item['quantity'] as int;
                    final color = item['selectedColor'] as String?;
                    final size = item['selectedSize'] as String?;

                    return CartItemWidget(
                      product: product,
                      quantity: quantity,
                      selectedColor: color,
                      selectedSize: size,
                    );
                  },
                ),
              ),

              /// الإجمالي
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TotaPrice(),
                    const SizedBox(height: 12),
                    CheckoutButtom(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
