import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_firebase_app/core/models/order_model.dart';

class CheckoutService {
  final _orders = FirebaseFirestore.instance.collection("orders");

  Future<void> placeOrder(OrderModel order) async {
    await _orders.add(order.toMap());
  }
}
