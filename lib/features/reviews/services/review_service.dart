// import 'package:cloud_firestore/cloud_firestore.dart';

// class ReviewService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// إضافة ريفيو لمنتج
//   Future<void> addReview({
//     required String productId,
//     required String userId,
//     required double rating,
//     required String comment,
//   }) async {
//     final reviewRef = _firestore
//         .collection("products")
//         .doc(productId)
//         .collection("reviews")
//         .doc(); // auto id

//     await reviewRef.set({
//       "userId": userId,
//       "rating": rating,
//       "comment": comment,
//       "createdAt": FieldValue.serverTimestamp(),
//     });

//     // تحديث الـ rating والـ reviewsCount في الـ product نفسه
//     final productRef = _firestore.collection("products").doc(productId);

//     await _firestore.runTransaction((transaction) async {//ec here 
//       final snapshot = await transaction.get(productRef);
//       final data = snapshot.data() as Map<String, dynamic>;

//       final currentRating = (data["rating"] ?? 0).toDouble();
//       final reviewsCount = (data["reviewsCount"] ?? 0) as int;

//       final newCount = reviewsCount + 1;
//       final newRating = ((currentRating * reviewsCount) + rating) / newCount;

//       transaction.update(productRef, {
//         "rating": newRating,
//         "reviewsCount": newCount,
//       });
//     });
//   }

//   /// جلب الريفيوهات الخاصة بمنتج
//   Stream<QuerySnapshot> getReviews(String productId) {
//     return _firestore
//         .collection("products")
//         .doc(productId)
//         .collection("reviews")
//         .orderBy("createdAt", descending: true)
//         .snapshots();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة ريفيو لمنتج مع منع التكرار
  Future<bool> addReview({
    required String productId,
    required String userId,
    required double rating,
    required String comment,
  }) async {
    final reviewsRef = _firestore
        .collection("products")
        .doc(productId)
        .collection("reviews");

    // منع التقييم المكرر
    final existing = await reviewsRef.where('userId', isEqualTo: userId).get();
    if (existing.docs.isNotEmpty) return false;

    final reviewRef = reviewsRef.doc();

    await reviewRef.set({
      "userId": userId,
      "rating": rating,
      "comment": comment,
      "createdAt": FieldValue.serverTimestamp(),
    });

    // تحديث الـ rating والـ reviewsCount في المنتج
    final productRef = _firestore.collection("products").doc(productId);
    await _firestore.runTransaction((transaction) async {
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

    return true;
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
