import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/review_service.dart';

class ReviewCubit extends Cubit<List<Map<String, dynamic>>> {
  final ReviewService _reviewService;

  ReviewCubit(this._reviewService) : super([]);

  void listenToReviews(String productId) {
    _reviewService.getReviews(productId).listen((snapshot) {
      final reviews = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "userId": doc["userId"],
          "rating": doc["rating"],
          "comment": doc["comment"],
          "createdAt": doc["createdAt"],
        };
      }).toList();
      emit(reviews);
    });
  }

  Future<void> addReview({
    required String productId,
    required String userId,
    required double rating,
    required String comment,
  }) async {
    await _reviewService.addReview(
      productId: productId,
      userId: userId,
      rating: rating,
      comment: comment,
    );
  }
}
