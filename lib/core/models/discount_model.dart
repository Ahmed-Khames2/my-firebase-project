import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountModel {
  final String id;
  final String code;
  final double? percent; // e.g. 20 => 20% off
  final double? amount; // fixed amount off
  final bool isActive;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String createdBy; // admin userId
  final DateTime createdAt;

  DiscountModel({
    required this.id,
    required this.code,
    this.percent,
    this.amount,
    this.isActive = true,
    this.startsAt,
    this.endsAt,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "code": code,
      "percent": percent,
      "amount": amount,
      "isActive": isActive,
      "startsAt": startsAt != null ? Timestamp.fromDate(startsAt!) : null,
      "endsAt": endsAt != null ? Timestamp.fromDate(endsAt!) : null,
      "createdBy": createdBy,
      "createdAt": Timestamp.fromDate(createdAt),
    }..removeWhere((k, v) => v == null);
  }

  factory DiscountModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return DiscountModel(
      id: doc.id,
      code: map['code'] ?? '',
      percent: map['percent'] != null ? (map['percent'] as num).toDouble() : null,
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
      isActive: map['isActive'] ?? true,
      startsAt: map['startsAt'] != null ? (map['startsAt'] as Timestamp).toDate() : null,
      endsAt: map['endsAt'] != null ? (map['endsAt'] as Timestamp).toDate() : null,
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// helper: apply discount to a total (returns discounted total)
  double apply(double total) {
    if (!isActive) return total;
    final now = DateTime.now();
    if (startsAt != null && now.isBefore(startsAt!)) return total;
    if (endsAt != null && now.isAfter(endsAt!)) return total;

    if (percent != null) {
      return total * (1 - percent! / 100.0);
    } else if (amount != null) {
      return (total - amount!).clamp(0, double.infinity);
    }
    return total;
  }
}
// await FirebaseFirestore.instance.collection('discounts').add({
//   "code": "SALE20",
//   "percent": 20,
//   "isActive": true,
//   "createdBy": adminUid,
//   "createdAt": FieldValue.serverTimestamp(),
// });
