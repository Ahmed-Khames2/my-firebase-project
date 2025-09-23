import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_firebase_app/pages/models/product_model.dart';

class ProductService {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  // 🟢 إضافة منتج
  Future<void> addProduct(ProductModel product) async {
    try {
      await productsCollection.doc(product.id).set(product.toMap());
    } catch (e) {
      throw Exception("Error adding product: $e");
    }
  }

  // 🟡 تعديل منتج
  Future<void> updateProduct(ProductModel product) async {
    try {
      await productsCollection.doc(product.id).update(product.toMap());
    } catch (e) {
      throw Exception("Error updating product: $e");
    }
  }

  // 🔴 حذف منتج
  Future<void> deleteProduct(String productId) async {
    try {
      await productsCollection.doc(productId).delete();
    } catch (e) {
      throw Exception("Error deleting product: $e");
    }
  }

  // 🔄 جلب كل المنتجات
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await productsCollection.get();
      return snapshot.docs
          .map((doc) =>
              ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}
