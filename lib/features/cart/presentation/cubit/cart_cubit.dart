import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/cart_item.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]) {
    loadCart();
  }

  void addToCart(CartItem item) {
    final index = state.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      state[index].quantity += item.quantity;
      emit(List.from(state));
    } else {
      emit([...state, item]);
    }
    saveCart();
  }

  void removeFromCart(int id) {
    emit(state.where((i) => i.id != id).toList());
    saveCart();
  }

  void increaseQuantity(int id) {
    final index = state.indexWhere((i) => i.id == id);
    if (index >= 0) {
      state[index].quantity += 1;
      emit(List.from(state));
      saveCart();
    }
  }

  void decreaseQuantity(int id) {
    final index = state.indexWhere((i) => i.id == id);
    if (index >= 0 && state[index].quantity > 1) {
      state[index].quantity -= 1;
      emit(List.from(state));
      saveCart();
    }
  }

  double get total => state.fold(0, (sum, item) => sum + item.price * item.quantity);

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = state.map((e) => json.encode({
          'id': e.id,
          'title': e.title,
          'thumbnail': e.thumbnail,
          'price': e.price,
          'quantity': e.quantity,
        })).toList();
    await prefs.setStringList('cart_items', cartJson);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList('cart_items') ?? [];
    final items = cartJson.map((e) {
      final map = json.decode(e);
      return CartItem(
        id: map['id'],
        title: map['title'],
        thumbnail: map['thumbnail'],
        price: map['price'],
        quantity: map['quantity'],
      );
    }).toList();
    emit(items);
  }
}
