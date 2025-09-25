import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/models/product_model.dart';

class CartCubit extends Cubit<List<Map<String, dynamic>>> {
  CartCubit() : super([]);

  /// إضافة منتج للكارت
  void addToCart(ProductModel product) {
    final index = state.indexWhere((item) => item['product'].id == product.id);
    if (index == -1) {
      final newCart = List<Map<String, dynamic>>.from(state);
      newCart.add({"product": product, "quantity": 1});
      emit(newCart);
    } else {
      increaseQuantity(product.id);
    }
  }

  /// إزالة منتج من الكارت
  void removeFromCart(String productId) {
    final newCart = state.where((item) => item['product'].id != productId).toList();
    emit(newCart);
  }

  /// زيادة الكمية
  void increaseQuantity(String productId) {
    final newCart = List<Map<String, dynamic>>.from(state);
    final index = newCart.indexWhere((item) => item['product'].id == productId);
    if (index != -1) {
      newCart[index]['quantity']++;
      emit(newCart);
    }
  }

  /// تقليل الكمية
  void decreaseQuantity(String productId) {
    final newCart = List<Map<String, dynamic>>.from(state);
    final index = newCart.indexWhere((item) => item['product'].id == productId);
    if (index != -1 && newCart[index]['quantity'] > 1) {
      newCart[index]['quantity']--;
      emit(newCart);
    } else {
      removeFromCart(productId);
    }
  }

  /// حساب الإجمالي
  double get total {
    return state.fold(0, (sum, item) {
      final product = item['product'] as ProductModel;
      final quantity = item['quantity'] as int;
      final price = product.discountPrice ?? product.price;
      return sum + (price * quantity);
    });
  }

  /// مسح الكارت
  void clearCart() {
    emit([]);
  }
}
