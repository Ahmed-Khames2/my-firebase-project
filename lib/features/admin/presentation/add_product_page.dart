import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/constant/consatnt.dart';
import 'package:my_firebase_app/core/helper/show_snack_bar.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_state.dart';
import 'package:uuid/uuid.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/CustomButton.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/CustomInputField.dart';
import '../service/product_service.dart';

class AddProductPage extends StatefulWidget {
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
  final _colorsController = TextEditingController();
  final _sizesController = TextEditingController();
  String _selectedCategory = Categories.all[1]; // افتراضي "Electronics"

  // 🖼️ list of image URL controllers
  final List<TextEditingController> _imageControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _colorsController.dispose();
    _sizesController.dispose();
    for (var c in _imageControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(ProductService()),
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            _nameController.clear();
            _descController.clear();
            _priceController.clear();
            _discountPriceController.clear();
            _colorsController.clear();
            _sizesController.clear();
            for (var c in _imageControllers) c.clear();

            setState(() => _selectedCategory = Categories.all[1]);

            showCustomSnackBar(context, "✅ ${state.message}");
            context.read<ProductCubit>().fetchProducts();
          } else if (state is ProductFailure) {
            showCustomSnackBar(
              context,
              "❌ Error: ${state.error}",
              success: false,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProductLoading;

          return Scaffold(
            appBar: AppBar(title: const Text("Add Product")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    InputField(
                      controller: _nameController,
                      label: "Product Name",
                      validator: (val) => val!.isEmpty ? "Enter name" : null,
                    ),
                    InputField(
                      controller: _descController,
                      label: "Description",
                      validator:
                          (val) => val!.isEmpty ? "Enter description" : null,
                    ),
                    InputField(
                      controller: _priceController,
                      label: "Price",
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? "Enter price" : null,
                    ),
                    InputField(
                      controller: _discountPriceController,
                      label: "Discount Price",
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      items:
                          Categories.all
                              .skip(1) // skip "All"
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    InputField(
                      controller: _colorsController,
                      label: "Colors (comma separated)",
                    ),
                    InputField(
                      controller: _sizesController,
                      label: "Sizes (comma separated)",
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Image URLs:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    // 🖼️ عرض كل TextField للصور
                    ..._imageControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;
                      return Row(
                        children: [
                          Expanded(
                            child: InputField(
                              controller: controller,
                              label: "Image URL ${index + 1}",
                              validator:
                                  (val) =>
                                      val!.isEmpty ? "Enter image URL" : null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              if (_imageControllers.length > 1) {
                                setState(
                                  () => _imageControllers.removeAt(index),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    }),

                    TextButton.icon(
                      onPressed: () {
                        setState(
                          () => _imageControllers.add(TextEditingController()),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add another image"),
                    ),

                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed:
                          isLoading
                              ? () {}
                              : () {
                                if (!_formKey.currentState!.validate()) return;

                                final product = ProductModel(
                                  id: const Uuid().v4(),
                                  name: _nameController.text.trim(),
                                  description: _descController.text.trim(),
                                  price:
                                      double.tryParse(_priceController.text) ??
                                      0,
                                  discountPrice: double.tryParse(
                                    _discountPriceController.text,
                                  ),
                                  category: _selectedCategory,
                                  colors:
                                      _colorsController.text
                                          .split(',')
                                          .map((e) => e.trim())
                                          .toList(),
                                  sizes:
                                      _sizesController.text
                                          .split(',')
                                          .map((e) => e.trim())
                                          .toList(),
                                  images:
                                      _imageControllers
                                          .map((c) => c.text.trim())
                                          .where((url) => url.isNotEmpty)
                                          .toList(),
                                  rating: '',
                                  reviewsCount: [],
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );

                                context.read<ProductCubit>().addProduct(
                                  product,
                                );
                              },
                      text: "Save Product",
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
