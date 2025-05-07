import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget
{
  final String text;
  final Color color;

  const CustomLabel({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, color: color),
      ),
    );
  }
}