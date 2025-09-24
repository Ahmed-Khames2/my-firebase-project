import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_firebase_app/core/constant/consatnt.dart';
import 'package:my_firebase_app/core/models/product_model.dart';
import 'package:my_firebase_app/features/admin/cubits/admin_cubit/admin_state.dart';
import 'package:my_firebase_app/features/admin/service/product_service.dart';
class ProductCubit extends Cubit<ProductState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProductService _productService;
  StreamSubscription? _subscription;

  // حفظ الكاتيجوري المحددة
  String selectedCategory = Categories.all.first;

  ProductCubit(this._productService) : super(ProductInitial());

  // ================== Stream Fetch ==================
  void fetchProducts() {
    emit(ProductLoading());
    _subscription?.cancel();
    _subscription = _firestore.collection('products').snapshots().listen(
      (snapshot) {
        final products =
            snapshot.docs.map((doc) => ProductModel.fromDoc(doc)).toList();
        emit(ProductLoaded(products: products, filteredProducts: products));
      },
      onError: (e) {
        emit(ProductError(error: e.toString()));
      },
    );
  }

  // ================== CRUD ==================
  Future<void> addProduct(ProductModel product) async {
    try {
      await _productService.addProduct(product);
      emit(ProductOperationSuccess(message: "Product added successfully"));
    } catch (e) {
      emit(ProductFailure(error: e.toString()));
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _productService.updateProduct(product);
      emit(ProductOperationSuccess(message: "Product updated successfully"));
    } catch (e) {
      emit(ProductFailure(error: e.toString()));
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _productService.deleteProduct(id);
      emit(ProductOperationSuccess(message: "Product deleted successfully"));
    } catch (e) {
      emit(ProductFailure(error: e.toString()));
    }
  }

  // ================== Search & Filter ==================
  void searchProducts(String query) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered = currentState.products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(currentState.copyWith(filteredProducts: filtered));
    }
  }

  void filterByCategory(String category) {
    selectedCategory = category; // حفظ الكاتيجوري المحددة
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      if (category == Categories.all.first) {
        emit(currentState.copyWith(filteredProducts: currentState.products));
      } else {
        final filtered = currentState.products
            .where((p) => p.category.toLowerCase() == category.toLowerCase())
            .toList();
        emit(currentState.copyWith(filteredProducts: filtered));
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
