import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class SelphIDImage extends StatelessWidget {
  const SelphIDImage(this.label, this.image, {super.key, this.portrait = false});

  final String label;
  final String? image;
  final bool portrait;

  @override
  Widget build(BuildContext context) {
    final bytes = _decode(image);
    if (bytes == null) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: portrait ? 1 : 1.58,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.28)),
              image: DecorationImage(fit: BoxFit.contain, image: MemoryImage(bytes)),
            ),
          ),
        ),
      ],
    );
  }

  Uint8List? _decode(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      return base64Decode(value);
    } catch (_) {
      return null;
    }
  }
}
