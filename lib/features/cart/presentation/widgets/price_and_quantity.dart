
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:my_firebase_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:my_firebase_app/features/cart/presentation/widgets/custom_icone.dart';

class PriceAndQuantity extends StatelessWidget {
  const PriceAndQuantity({
    super.key,
    required this.item,
  });

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "\$${item.price.toStringAsFixed(2)}",
          style: AppStyles.body2SemiBold,
        ),
    
        const Spacer(),
        CustomIcone(
          item: item,
          icone: Icons.remove,
          onPressed:
              () => context
                  .read<CartCubit>()
                  .decreaseQuantity(item.id),
        ),
        SizedBox(width: 12),
        Text('${item.quantity}'),
        SizedBox(width: 12),
    
        CustomIcone(
          item: item,
          icone: Icons.add,
          onPressed:
              () => context
                  .read<CartCubit>()
                  .increaseQuantity(item.id),
        ),
      ],
    );
  }
}
