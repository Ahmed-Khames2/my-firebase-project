import 'package:equatable/equatable.dart';
import 'package:my_firebase_app/core/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;

  const ProductLoaded({required this.products, required this.filteredProducts});

  ProductLoaded copyWith({List<ProductModel>? products, List<ProductModel>? filteredProducts}) {
    return ProductLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
    );
  }

  @override
  List<Object?> get props => [products, filteredProducts];
}

class ProductOperationSuccess extends ProductState {
  final String message;
  const ProductOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductFailure extends ProductState {
  final String error;
  const ProductFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ProductError extends ProductState {
  final String error;
  const ProductError({required this.error});

  @override
  List<Object?> get props => [error];
}
