import 'package:flutter/material.dart';

class ProductColors extends StatelessWidget {
  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onSelect;

  const ProductColors({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onSelect,
  });

  Color getColorFromName(String color) {
    switch (color.toLowerCase()) {
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
      case "black":
        return Colors.black;
      case "white":
        return Colors.white;
      case "Brown":
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      children:
          colors.map((color) {
            final colorValue = getColorFromName(color);
            final isSelected = selectedColor == color;
            return GestureDetector(
              onTap: () => onSelect(color),
              child: CircleAvatar(
                radius: isSelected ? 20 : 18,
                backgroundColor: colorValue,
                child:
                    isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
              ),
            );
          }).toList(),
    );
  }
}
