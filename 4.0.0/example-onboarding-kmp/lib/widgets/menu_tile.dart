import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.tint,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = tint ?? scheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: tint ?? scheme.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(color: color))),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.35)),
            ],
          ),
        ),
      ),
    );
  }
}
