import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/constant/consatnt.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/core/helper/show_snack_bar.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_cubit.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_state.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/CustomButton.dart';
import 'package:my_firebase_app/features/admin/presentation/widgets/CustomInputField.dart';
import '../service/product_service.dart';

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
  late TextEditingController _colorsController;
  late TextEditingController _sizesController;

  String? _selectedCategory;

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
    _colorsController = TextEditingController(
      text: widget.product.colors.join(','),
    );
    _sizesController = TextEditingController(
      text: widget.product.sizes.join(','),
    );

    // ✅ set selected category
    _selectedCategory =
        Categories.all.contains(widget.product.category)
            ? widget.product.category
            : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(ProductService()),
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            showCustomSnackBar(context, "✅ Product updated successfully");
            Navigator.pop(context);
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
            appBar: AppBar(title: const Text("Edit Product")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    InputField(
                      controller: _nameController,
                      label: "Product Name",
                    ),
                    InputField(
                      controller: _descController,
                      label: "Description",
                    ),
                    InputField(
                      controller: _priceController,
                      label: "Price",
                      keyboardType: TextInputType.number,
                    ),
                    InputField(
                      controller: _discountPriceController,
                      label: "Discount Price",
                      keyboardType: TextInputType.number,
                    ),

                    // ✅ Dropdown for category
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      items:
                          Categories.all
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      },
                      validator:
                          (val) =>
                              val == null ? "Please select category" : null,
                    ),

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
                      isLoading: isLoading,
                      text: "Update Product",
                      onPressed:
                          isLoading
                              ? () {}
                              : () {
                                if (!_formKey.currentState!.validate()) return;

                                final updatedProduct = widget.product.copyWith(
                                  name: _nameController.text.trim(),
                                  description: _descController.text.trim(),
                                  price:
                                      double.tryParse(_priceController.text) ??
                                      0,
                                  discountPrice: double.tryParse(
                                    _discountPriceController.text,
                                  ),
                                  category: _selectedCategory!.trim(),
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
                                  updatedAt: DateTime.now(),
                                );

                                BlocProvider.of<ProductCubit>(context).updateProduct(updatedProduct);

                              },
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
