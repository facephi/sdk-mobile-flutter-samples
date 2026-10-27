import 'dart:typed_data';

import 'package:flutter/material.dart';

class SelphiImage extends StatelessWidget {
  const SelphiImage(this.image, {super.key});

  final Uint8List? image;

  @override
  Widget build(BuildContext context)
  {
    if (image == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rostro', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Align(
          child: Container(
            height: 210,
            width: 164,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
              image: DecorationImage(fit: BoxFit.cover, image: MemoryImage(image!)),
            ),
          ),
        ),
      ],
    );
  }
}
