import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_firebase_app/core/models/order_model.dart';
import 'package:my_firebase_app/core/models/payment_method_model.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/features/address/presentation/cubit/addrescubit.dart';
import 'package:my_firebase_app/features/address/presentation/pages/add_address_page.dart';
import 'package:my_firebase_app/features/address/presentation/pages/address_list_page.dart';
import 'package:my_firebase_app/features/address/service/address_service.dart';
import 'package:my_firebase_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:my_firebase_app/features/checkout/cubit/checkout_cubit.dart';
import 'package:my_firebase_app/features/checkout/service/chechout_service.dart';
import 'package:my_firebase_app/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:my_firebase_app/features/payment/presentation/pages/select_paymethod_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutCubit = context.read<CheckoutCubit>();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// 📌 اختيار العنوان
              ListTile(
                title: const Text("Delivery Address"),
                subtitle:
                    state.selectedAddress == null
                        ? const Text("No address selected")
                        : Text(
                          "${state.selectedAddress!.fullName}, ${state.selectedAddress!.city}, ${state.selectedAddress!.street}, مبنى ${state.selectedAddress!.building}",
                        ),

                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () async {
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (_) =>
                                    AddressCubit(AddressService())
                                      ..loadAddresses(userId),
                            child: AddressListPage(userId: userId),
                          ),
                    ),
                  );

                  if (selectedAddress != null) {
                    checkoutCubit.selectAddress(selectedAddress);
                  }
                },
              ),
              const Divider(),

              /// 📌 Payment method
              ListTile(
                title: const Text("Payment Method"),
                subtitle: Text(state.selectedPaymentMethod ?? "Choose payment"),
                trailing: const Icon(Icons.payment),
                // onTap: () async {
                //   final method = await Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder:
                //           (_) => BlocProvider.value(
                //             value:
                //                 context.read<PaymentCubit>()
                //                   ..loadMethods(userId),
                //             child: PaymentMethodPage(userId: userId),
                //           ),
                //     ),
                //   );

                //   if (method != null && method is PaymentMethodModel) {
                //     checkoutCubit.selectPayment(method.type);
                //   }
                // },
              ),

              const Divider(),

              /// 📌 Promo Code
              // TextField(
              //   decoration: const InputDecoration(labelText: "Promo Code"),
              //   onSubmitted: (value) {
              //     checkoutCubit.applyPromo(value);
              //   },
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (state.selectedAddress == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select address")),
                    );
                    return;
                  }

                  final user = FirebaseAuth.instance.currentUser!;
                  final cartItems = context.read<CartCubit>().state;

                  if (cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Your cart is empty")),
                    );
                    return;
                  }

                  // 🛒 تحويل الكارت لمنتجات الأوردر
                  final products =
                      cartItems.map((item) {
                        final product = item['product'] as ProductModel;
                        final quantity = item['quantity'] as int;
                        final color = item['selectedColor'] as String?;
                        final size = item['selectedSize'] as String?;
                        return {
                          "id": product.id,
                          "name": product.name,
                          "price": product.discountPrice ?? product.price,
                          "quantity": quantity,
                          "color": color,
                          "size": size,
                        };
                      }).toList();

                  final order = OrderModel(
                    id: "", // Firestore هيعمل ID
                    userId: user.uid,
                    products: products,
                    total: context.read<CartCubit>().total,
                    addressId: state.selectedAddress!.id,
                    paymentMethodId: state.selectedPaymentMethod ?? "cash",
                    status: "pending",
                    promoCode: state.promoCode,
                    createdAt: DateTime.now(),
                  );

                  await CheckoutService().placeOrder(order);

                  // 🧹 فضي الكارت بعد الطلب
                  context.read<CartCubit>().clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order placed successfully")),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Place Order"),
              ),
            ],
          );
        },
      ),
    );
  }
}
