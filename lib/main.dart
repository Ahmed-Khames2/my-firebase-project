import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/features/Auth/cubit/auth_cubit.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';
import 'package:my_firebase_app/features/admin/service/product_service.dart';
import 'package:my_firebase_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:my_firebase_app/features/checkout/cubit/checkout_cubit.dart';
import 'package:my_firebase_app/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:my_firebase_app/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:my_firebase_app/features/payment/service/payment_service.dart';
import 'package:my_firebase_app/features/reviews/cubit/review_cubit.dart';
import 'package:my_firebase_app/features/reviews/services/review_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favCubit = FavoriteCubit();
  final cart = CartCubit();
  await cart.loadCart();
  await favCubit.loadFavorites();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
          create: (_) => ProductCubit(ProductService())..fetchProducts(),
        ),
        BlocProvider.value(value: favCubit, child: const MyApp()),
        BlocProvider.value(value: cart, child: const MyApp()),
        BlocProvider(
          create: (_) => ReviewCubit(ReviewService()),
        ),  
        BlocProvider(
          create: (_) => CheckoutCubit(),
        ),  BlocProvider(
          create: (_) => PaymentCubit(PaymentMethodService()),
        ), 
        // PaymentCubit
        // هنا مهم تمرر ReviewService
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.login,
    );
  }
}
