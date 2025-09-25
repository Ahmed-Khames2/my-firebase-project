
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageOfCard extends StatelessWidget {
  const ImageOfCard({
    super.key,
    required this.item,
  });

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 236, 236, 236),
      ),
      child: CachedNetworkImage(
        imageUrl: item.thumbnail,
        width: 90,
        height: 90,
        fit: BoxFit.scaleDown,
        // ),
      ),
    );
  }
}
