import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة ريفيو لمنتج
  Future<void> addReview({
    required String productId,
    required String userId,
    required double rating,
    required String comment,
  }) async {
    final reviewRef = _firestore
        .collection("products")
        .doc(productId)
        .collection("reviews")
        .doc(); // auto id

    await reviewRef.set({
      "userId": userId,
      "rating": rating,
      "comment": comment,
      "createdAt": FieldValue.serverTimestamp(),
    });

    // تحديث الـ rating والـ reviewsCount في الـ product نفسه
    final productRef = _firestore.collection("products").doc(productId);

    await _firestore.runTransaction((transaction) async {//ec here 
      final snapshot = await transaction.get(productRef);
      final data = snapshot.data() as Map<String, dynamic>;

      final currentRating = (data["rating"] ?? 0).toDouble();
      final reviewsCount = (data["reviewsCount"] ?? 0) as int;

      final newCount = reviewsCount + 1;
      final newRating = ((currentRating * reviewsCount) + rating) / newCount;

      transaction.update(productRef, {
        "rating": newRating,
        "reviewsCount": newCount,
      });
    });
  }

  /// جلب الريفيوهات الخاصة بمنتج
  Stream<QuerySnapshot> getReviews(String productId) {
    return _firestore
        .collection("products")
        .doc(productId)
        .collection("reviews")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
