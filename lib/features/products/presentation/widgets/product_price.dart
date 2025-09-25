import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/styles.dart';

class ProductPrice extends StatelessWidget {
  final double price;
  final double? discountPrice;

  const ProductPrice({
    super.key,
    required this.price,
    this.discountPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.greyLighter,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "\$${price.toStringAsFixed(2)}",
            style: AppStyles.header1.copyWith(
              color: AppColors.secondary,
              fontSize: 16,
            ),
          ),
        ),
        if (discountPrice != null) ...[
          const SizedBox(width: 12),
          Text(
            "\$${discountPrice!.toStringAsFixed(2)}",
            style: AppStyles.body1Regular.copyWith(
              color: Colors.grey,
              fontSize: 16,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}
