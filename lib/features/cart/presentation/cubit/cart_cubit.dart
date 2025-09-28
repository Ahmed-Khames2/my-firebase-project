import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_firebase_app/core/models/product_model.dart';

class CartCubit extends Cubit<List<Map<String, dynamic>>> {
  CartCubit() : super([]) {
    loadCart();
  }

  /// إضافة منتج للكارت مع اللون والمقاس
  void addToCart(ProductModel product, {String? color, String? size}) {
    final index = state.indexWhere((item) =>
        item['product'].id == product.id &&
        item['selectedColor'] == color &&
        item['selectedSize'] == size);

    final newCart = List<Map<String, dynamic>>.from(state);

    if (index == -1) {
      newCart.add({
        "product": product,
        "quantity": 1,
        "selectedColor": color,
        "selectedSize": size,
      });
    } else {
      newCart[index]['quantity']++;
    }

    emit(newCart);
    _saveCart();
  }

  /// إزالة منتج من الكارت
  void removeFromCart(String productId, {String? color, String? size}) {
    final newCart = state.where((item) =>
        !(item['product'].id == productId &&
          item['selectedColor'] == color &&
          item['selectedSize'] == size)).toList();
    emit(newCart);
    _saveCart();
  }

  /// زيادة الكمية
  void increaseQuantity(String productId, {String? color, String? size}) {
    final newCart = List<Map<String, dynamic>>.from(state);
    final index = newCart.indexWhere((item) =>
        item['product'].id == productId &&
        item['selectedColor'] == color &&
        item['selectedSize'] == size);
    if (index != -1) {
      newCart[index]['quantity']++;
      emit(newCart);
      _saveCart();
    }
  }

  /// تقليل الكمية
  void decreaseQuantity(String productId, {String? color, String? size}) {
    final newCart = List<Map<String, dynamic>>.from(state);
    final index = newCart.indexWhere((item) =>
        item['product'].id == productId &&
        item['selectedColor'] == color &&
        item['selectedSize'] == size);
    if (index != -1 && newCart[index]['quantity'] > 1) {
      newCart[index]['quantity']--;
      emit(newCart);
    } else {
      removeFromCart(productId, color: color, size: size);
      return;
    }
    _saveCart();
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
    _saveCart();
  }

  /// حفظ الكارت في SharedPreferences
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = state.map((item) {
      final product = item['product'] as ProductModel;
      return {
        "product": product.toJsonMap(),
        "quantity": item['quantity'],
        "selectedColor": item['selectedColor'],
        "selectedSize": item['selectedSize'],
      };
    }).toList();
    prefs.setString('cart', jsonEncode(jsonData));
  }

  /// تحميل الكارت من SharedPreferences
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cart');
    if (jsonString != null) {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final loadedCart = jsonData.map((item) {
        return {
          "product": ProductModel.fromJson(item['product']),
          "quantity": item['quantity'],
          "selectedColor": item['selectedColor'],
          "selectedSize": item['selectedSize'],
        };
      }).toList();
      emit(loadedCart);
    }
  }
}
