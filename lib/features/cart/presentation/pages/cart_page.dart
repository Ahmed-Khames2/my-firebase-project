import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/widgets/empty_widget.dart';
import 'package:my_firebase_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:my_firebase_app/features/cart/presentation/widgets/Image_of_card.dart';
import 'package:my_firebase_app/features/cart/presentation/widgets/price_and_quantity.dart';
import 'package:my_firebase_app/features/cart/presentation/widgets/titel_and_delete.dart';
import 'package:my_firebase_app/features/cart/presentation/widgets/total_and_checkout.dart';
import 'package:my_firebase_app/features/products/presentation/widgets/custom_app_bar_details_page.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CartAppBar(text: 'My Cart', onBack: () {
        // 
      },),
      body: BlocBuilder<CartCubit, List>(
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
              // قائمة المنتجات
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: cartItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 6,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // صورة المنتج
                          ImageOfCard(item: item),
                          const SizedBox(width: 12),
                          // باقي التفاصيل
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row: العنوان + زر الحذف
                                TitelAndDelete(item: item),
                                const SizedBox(height: 12),

                                // Row: السعر + أدوات التحكم في الكمية
                                PriceAndQuantity(item: item),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // القسم السفلي: المجموع + زرار checkout
              TotalAndCheckout(),
            ],
          );
        },
      ),
    );
  }
}
