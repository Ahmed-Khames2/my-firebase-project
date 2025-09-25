import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/features/reviews/cubit/review_cubit.dart';
import 'package:my_firebase_app/features/reviews/presentation/AddReviewBottomSheet.dart';
import 'package:my_firebase_app/features/reviews/services/review_service.dart';

class ProductReviewsPage extends StatelessWidget {
  final String productId;

  const ProductReviewsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewCubit(ReviewService())..listenToReviews(productId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Reviews")),
        body: BlocBuilder<ReviewCubit, List<Map<String, dynamic>>>(
          builder: (context, reviews) {
            if (reviews.isEmpty) {
              return const Center(child: Text("No reviews yet."));
            }

            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(review['comment'] ?? ''),
                  subtitle: Text("⭐ ${review['rating']}"),
                  trailing: Text(
                    review['createdAt'] != null
                        ? review['createdAt'].toDate().toString().split(' ')[0]
                        : '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => AddReviewBottomSheet(productId: productId),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
