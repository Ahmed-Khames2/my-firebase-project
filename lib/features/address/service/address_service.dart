import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_firebase_app/features/address/data/model/address_model.dart';

class AddressService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addAddress(AddressModel address) async {
    await _firestore
        .collection("addresses")
        .doc(address.id)
        .set(address.toMap());
  }

  Future<List<AddressModel>> getUserAddresses(String userId) async {
    final snapshot = await _firestore
        .collection("addresses")
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => AddressModel.fromMap(doc.data()))
        .toList();
  }
}
