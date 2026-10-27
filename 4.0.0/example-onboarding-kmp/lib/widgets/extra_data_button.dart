import 'package:flutter/material.dart';

class ExtraDataButton extends StatelessWidget {
  const ExtraDataButton({super.key, required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: enabled ? onPressed : null,
          icon: const Icon(Icons.dataset_outlined),
          label: const Text('Get ExtraData'),
        ),
        if (!enabled) ...[
          const SizedBox(height: 8),
          Text(
            'Se activa al tener rostro y documento.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.55)),
          ),
        ],
      ],
    );
  }
}
