
// ignore_for_file: use_build_context_synchronously

  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';

void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

    void showCustomSnackBar(
    BuildContext context,
    String message, {
    bool success = true,
  }) {
    final color = success ? AppColors.primary : Colors.red;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyles.body1SemiBold.copyWith(color: Colors.white),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

    void showProductOptions(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(product.name),
            content: const Text("Choose an action"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.editProduct,
                    arguments: product,
                  );
                  // مش محتاج fetchProducts() لأن عندنا Stream مباشر
                },
                child: const Text("✏️ Edit"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await context.read<ProductCubit>().deleteProduct(product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("🗑️ Product deleted")),
                  );
                  // Stream مباشر، مش محتاج fetchProducts()
                },
                child: const Text(
                  "🗑️ Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
    /// 🎨 Helper لتحويل String → Color
  Color getColorFromName(String color) {
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
