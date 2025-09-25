import 'package:flutter/material.dart';
import 'package:my_firebase_app/features/Auth/presentation/login_page.dart';
import 'package:my_firebase_app/features/Auth/presentation/resgister_page.dart';
import 'package:my_firebase_app/features/admin/presentation/AdminDashboard.dart';
import 'package:my_firebase_app/features/admin/presentation/add_product_page.dart';
import 'package:my_firebase_app/features/admin/presentation/edit_product.dart';
import 'package:my_firebase_app/features/layout/BottomNavLayout.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/features/products/presentation/product_details_page.dart';
import 'package:my_firebase_app/features/products/presentation/products_page.dart';

class AppRoutes {
  static const String layout = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String productPage = '/productPage';
  static const String adminDashboard = '/adminDashboard';
  static const String productDetails = '/productDetails';
  static const String addProduct = "/addProduct";
  static const String editProduct = "/editProduct";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case layout:
        return MaterialPageRoute(builder: (_) => const BottomNavLayout());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case productPage:
        return MaterialPageRoute(builder: (_) => ProductsPage());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => AdminDashboard());
      case productDetails:
        final args = settings.arguments;
        if (args is ProductModel) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: args),
          );
        }
        return _errorRoute("ProductDetails needs ProductModel as arguments.");

      case addProduct:
        return MaterialPageRoute(builder: (_) => AddProductPage());
      case editProduct:
        final args = settings.arguments;
        if (args is ProductModel) {
          return MaterialPageRoute(
            builder: (_) => EditProductPage(product: args),
          );
        }
        return _errorRoute("EditProductPage needs ProductModel as arguments.");
      default:
        return _errorRoute("Route not found: ${settings.name}");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Route Error')),
            body: Center(child: Text(message)),
          ),
    );
  }
}
