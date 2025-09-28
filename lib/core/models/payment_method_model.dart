import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel {
  final String id;
  final String userId;
  final String type; // "cash", "card", "fawry", etc.
  final Map<String, dynamic>? details; // e.g. { "cardHolder": "...", "last4": "4242", "expiry": "12/25" }
  final bool isDefault;
  final DateTime createdAt;

  PaymentMethodModel({
    required this.id,
    required this.userId,
    required this.type,
    this.details,
    this.isDefault = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "type": type,
      "details": details,
      "isDefault": isDefault,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

  factory PaymentMethodModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return PaymentMethodModel(
      id: doc.id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'cash',
      details: (map['details'] as Map<String, dynamic>?) ?? {},
      isDefault: map['isDefault'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
