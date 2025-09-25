import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_firebase_app/core/models/product_model.dart';

class FavoriteCubit extends Cubit<List<ProductModel>> {
  FavoriteCubit() : super([]);

  /// تحميل المنتجات المفضلة
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favJson = prefs.getStringList("favorites") ?? [];

    final favProducts = favJson
        .map((p) => ProductModel.fromJson(jsonDecode(p)))
        .toList();

    emit(favProducts);
  }

  /// إضافة/إزالة منتج من المفضلة
  Future<void> toggleFavorite(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final current = List<ProductModel>.from(state);

    if (current.any((p) => p.id == product.id)) {
      current.removeWhere((p) => p.id == product.id);
    } else {
      current.add(product);
    }

    final favJson =
        current.map((p) => jsonEncode(p.toMapWithId())).toList();

    await prefs.setStringList("favorites", favJson);
    emit(current);
  }

  /// فحص هل المنتج في المفضلة
  bool isFavorite(String productId) {
    return state.any((p) => p.id == productId);
  }
}
