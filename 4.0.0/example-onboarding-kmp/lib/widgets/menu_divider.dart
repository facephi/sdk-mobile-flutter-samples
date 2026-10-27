import 'package:flutter/material.dart';

class MenuDivider extends StatelessWidget {
  const MenuDivider({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: color);
  }
}
