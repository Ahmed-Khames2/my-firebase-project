// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../services/review_service.dart';

// class ReviewCubit extends Cubit<List<Map<String, dynamic>>> {
//   final ReviewService _reviewService;

//   ReviewCubit(this._reviewService) : super([]);

//   void listenToReviews(String productId) {
//     _reviewService.getReviews(productId).listen((snapshot) {
//       final reviews = snapshot.docs.map((doc) {
//         return {
//           "id": doc.id,
//           "userId": doc["userId"],
//           "rating": doc["rating"],
//           "comment": doc["comment"],
//           "createdAt": doc["createdAt"],
//         };
//       }).toList();
//       emit(reviews);
//     });
//   }

//   Future<void> addReview({
//     required String productId,
//     required String userId,
//     required double rating,
//     required String comment,
//   }) async {
//     await _reviewService.addReview(
//       productId: productId,
//       userId: userId,
//       rating: rating,
//       comment: comment,
//     );
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/review_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<bool> addReview({
    required String productId,
    required String userId,
    required double rating,
    required String comment,
  }) async {
    return await _reviewService.addReview(
      productId: productId,
      userId: userId,
      rating: rating,
      comment: comment,
    );
  }

  Map<int, int> getRatingDistribution() {
    final Map<int, int> dist = {1:0,2:0,3:0,4:0,5:0};
    for (var review in state) {
      final r = (review['rating'] as num).round();
      dist[r] = dist[r]! + 1;
    }
    return dist;
  }

  double get averageRating {
    if (state.isEmpty) return 0.0;
    double sum = state.fold(0.0, (prev, e) => prev + (e['rating'] as num));
    return sum / state.length;
  }
}
