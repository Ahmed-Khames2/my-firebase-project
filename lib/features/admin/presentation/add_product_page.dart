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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(ProductService()),
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            // تفريغ كل الفيلدات
            _nameController.clear();
            _descController.clear();
            _priceController.clear();
            _discountPriceController.clear();
            _colorsController.clear();
            _sizesController.clear();

            // إعادة اختيار الفئة الافتراضية
            setState(() => _selectedCategory = Categories.all[1]);

            showCustomSnackBar(context, "✅ ${state.message}");

            // تحديث المنتجات
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
                                  images: [],
                                  rating: '',
                                  reviews: [],
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
