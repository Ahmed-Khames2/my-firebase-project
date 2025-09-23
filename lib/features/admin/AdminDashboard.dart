import 'package:flutter/material.dart';
import 'package:my_firebase_app/features/admin/add_product_page.dart';

class AdminDashboard extends StatelessWidget {
  static String id = 'AdminDashboard';

  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("Add Product"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProductPage()),
            );
          },
        ),
      ),
    );
  }
}
