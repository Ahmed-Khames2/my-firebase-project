import 'package:flutter/material.dart';
import 'package:my_firebase_app/pages/models/product_model.dart';
import 'package:my_firebase_app/services/product_service.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _discountPriceController;
  late TextEditingController _categoryController;
  late TextEditingController _colorsController;
  late TextEditingController _sizesController;

  final ProductService _productService = ProductService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _discountPriceController = TextEditingController(
      text: widget.product.discountPrice?.toString() ?? "",
    );
    _categoryController = TextEditingController(text: widget.product.category);
    _colorsController = TextEditingController(
      text: widget.product.colors.join(','),
    );
    _sizesController = TextEditingController(
      text: widget.product.sizes.join(','),
    );
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final updatedProduct = widget.product.copyWith(
      //error here
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      discountPrice: double.tryParse(_discountPriceController.text),
      category: _categoryController.text.trim(),
      colors: _colorsController.text.split(',').map((e) => e.trim()).toList(),
      sizes: _sizesController.text.split(',').map((e) => e.trim()).toList(),
      updatedAt: DateTime.now(),
    );

    try {
      await _productService.updateProduct(updatedProduct);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Product updated")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
      print("❌ Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
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
                onPressed: _isLoading ? null : _updateProduct,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
