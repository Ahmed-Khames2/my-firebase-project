import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_firebase_app/core/models/payment_method_model.dart';

class PaymentMethodService {
  final _collection = FirebaseFirestore.instance.collection("payment_methods");

  Future<void> addPaymentMethod(PaymentMethodModel method) async {
    await _collection.add(method.toMap());
  }

  Future<List<PaymentMethodModel>> getUserMethods(String userId) async {
    final snapshot = await _collection
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs.map((doc) => PaymentMethodModel.fromDoc(doc)).toList();
  }

  Future<void> setDefaultMethod(String methodId, String userId) async {
    final batch = FirebaseFirestore.instance.batch();

    final query = await _collection.where("userId", isEqualTo: userId).get();
    for (var doc in query.docs) {
      batch.update(doc.reference, {"isDefault": doc.id == methodId});
    }

    await batch.commit();
  }
}
