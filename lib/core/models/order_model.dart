import 'package:cloud_firestore/cloud_firestore.dart';

/// products: each item is a map containing:
/// { "id", "name", "price", "quantity", "color", "size" }
class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> products;
  final double total;
  final String addressId; // or address string; we use addressId to reference addresses/{id}
  final String paymentMethodId; // reference to payment_methods/{id} OR string like "Cash"
  final String status; // pending, accepted, delivered, cancelled
  final String? promoCode;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.total,
    required this.addressId,
    required this.paymentMethodId,
    required this.status,
    this.promoCode,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "products": products,
      "total": total,
      "addressId": addressId,
      "paymentMethodId": paymentMethodId,
      "status": status,
      "promoCode": promoCode,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: map['userId'] ?? '',
      products: List<Map<String, dynamic>>.from(map['products'] ?? []),
      total: (map['total'] ?? 0).toDouble(),
      addressId: map['addressId'] ?? '',
      paymentMethodId: map['paymentMethodId'] ?? '',
      status: map['status'] ?? 'pending',
      promoCode: map['promoCode'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
// final orderRef = FirebaseFirestore.instance.collection('orders').doc();
// final order = {
//   "userId": currentUser.uid,
//   "products": cartItems.map((item) => {
//     "id": item['product'].id,
//     "name": item['product'].name,
//     "quantity": item['quantity'],
//     "color": item['selectedColor'],
//     "size": item['selectedSize'],
//     "price": item['product'].discountPrice ?? item['product'].price,
//   }).toList(),
//   "total": total,
//   "addressId": selectedAddressId,
//   "paymentMethodId": selectedPaymentMethodId,
//   "status": "pending",
//   "promoCode": appliedPromoCode,
//   "createdAt": FieldValue.serverTimestamp(),
// };
// await orderRef.set(order);
