import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/features/Auth/cubit/auth_cubit.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';
import 'package:my_firebase_app/features/admin/service/product_service.dart';
import 'package:my_firebase_app/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   final favCubit = FavoriteCubit();
  await favCubit.loadFavorites();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
          create: (_) => ProductCubit(ProductService())..fetchProducts(),
        ),
        BlocProvider.value(
      value: favCubit,
      child: const MyApp(),
    ),
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
