import 'package:cloud_firestore/cloud_firestore.dart';
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
            final cubit = context.read<ReviewCubit>();
            if (reviews.isEmpty) {
              return const Center(child: Text("No reviews yet."));
            }

            final distribution = cubit.getRatingDistribution();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Average rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(cubit.averageRating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < cubit.averageRating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text("(${reviews.length} ratings)"),
                    const SizedBox(height: 16),

                    // Rating breakdown
                    Column(
                      children: List.generate(5, (i) {
                        final star = 5 - i;
                        final count = distribution[star]!;
                        final percent = reviews.isEmpty ? 0.0 : count / reviews.length;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text("$star ★"),
                              const SizedBox(width: 8),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: percent,
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("$count"),
                            ],
                          ),
                        );
                      }),
                    ),
                    const Divider(height: 32),

                    // Reviews list
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: reviews.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < (review['rating'] as num).round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 18,
                              ),
                            ),
                          ),
                          subtitle: Text(review['comment'] ?? ''),
                          trailing: Text(
                            review['createdAt'] != null
                                ? (review['createdAt'] as Timestamp)
                                    .toDate()
                                    .toString()
                                    .split(' ')[0]
                                : '',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
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
