import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class ProductSizes extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSelect;

  const ProductSizes({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      children: sizes.map((size) {
        final isSelected = selectedSize == size;
        return ChoiceChip(
          label: Text(size),
          selected: isSelected,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
          ),
          onSelected: (_) => onSelect(size),
        );
      }).toList(),
    );
  }
}
