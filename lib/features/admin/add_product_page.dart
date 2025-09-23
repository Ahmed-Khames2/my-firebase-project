import 'package:flutter/material.dart';
import 'package:my_firebase_app/pages/models/product_model.dart';
import 'package:uuid/uuid.dart';
import '../../../services/product_service.dart';

class AddProductPage extends StatefulWidget {
  static String id = "AddProductPage";

  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _colorsController = TextEditingController();
  final _sizesController = TextEditingController();

  final ProductService _productService = ProductService();

  bool _isLoading = false;

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final String id = const Uuid().v4(); // generate unique ID

    final product = ProductModel(
      id: id,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      discountPrice: double.tryParse(_discountPriceController.text),
      category: _categoryController.text.trim(),
      colors: _colorsController.text.split(','),
      sizes: _sizesController.text.split(',').map((e) => e.trim()).toList(),
      images: [], // لسه هنضيف رفع الصور بعدين
      rating: "",
      reviews: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    try {
      await _productService.addProduct(product);
      // ✅ امسح الحقول
      _nameController.clear();
      _descController.clear();
      _priceController.clear();
      _discountPriceController.clear();
      _categoryController.clear();
      _colorsController.clear();
      _sizesController.clear();

      // _formKey.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Product added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Product Name"),
                validator: (val) => val!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (val) => val!.isEmpty ? "Enter description" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter price" : null,
              ),
              TextFormField(
                controller: _discountPriceController,
                decoration: const InputDecoration(labelText: "Discount Price"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              TextFormField(
                controller: _colorsController,
                decoration: const InputDecoration(
                  labelText: "Colors (comma separated)",
                ),
              ),
              TextFormField(
                controller: _sizesController,
                decoration: const InputDecoration(
                  labelText: "Sizes (comma separated)",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
