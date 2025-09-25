
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_firebase_app/core/theme/app_color.dart';
import 'package:my_firebase_app/core/theme/styles.dart';
import 'package:my_firebase_app/features/cart/presentation/cubit/cart_cubit.dart';

class TitelAndDelete extends StatelessWidget {
  const TitelAndDelete({
    super.key,
    required this.item,
  });

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.body2SemiBold,
          ),
        ),
        IconButton(
          onPressed:
              () => context
                  .read<CartCubit>()
                  .removeFromCart(item.id),
          icon: const Icon(
            Icons.delete_outline,
            color: AppColors.red,
          ),
        ),
      ],
    );
  }
}
