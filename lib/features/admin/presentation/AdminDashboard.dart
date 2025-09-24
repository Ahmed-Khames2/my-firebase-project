import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_firebase_app/core/routes/app_routes.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/features/admin/service/product_service.dart';

class AdminDashboard extends StatelessWidget {
  // static String id = 'AdminDashboard';

  final ProductService _productService = ProductService();

  AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.addProduct,
              ); // لو حابب تفتح AddProductPage، ضيف روت خاص بيها بعدين
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("❌ Error loading products"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products =
              snapshot.data!.docs
                  .map((doc) => ProductModel.fromDoc(doc))
                  .toList();

          if (products.isEmpty) {
            return const Center(child: Text("No products yet"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text("Price: \$${product.price}"),
                onTap: () {
                  _showProductOptions(context, product);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showProductOptions(BuildContext context, ProductModel product) {
    final rootContext = context; // نخزن context الأصلي للـ Scaffold

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(product.name),
            content: const Text("Choose an action"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // يقفل الـ Dialog
                  Navigator.pushNamed(
                    rootContext,
                    AppRoutes.editProduct,
                    arguments: product, // تمرير الـ ProductModel
                  );
                },
                child: const Text("✏️ Edit"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext); // يقفل الـ Dialog
                  await _productService.deleteProduct(product.id);

                  // هنا نستخدم context الأصلي مش بتاع الـ Dialog
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    const SnackBar(content: Text("🗑️ Product deleted")),
                  );
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
}
