import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/styles.dart';

class ProductReviews extends StatelessWidget {
  final List<String> reviews;

  const ProductReviews({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Reviews", style: AppStyles.header1),
        const SizedBox(height: 8),
        Column(
          children: reviews.map((review) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.black87),
                ),
                title: Text(review, style: AppStyles.body1Regular),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
