import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? function;
  final bool outlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.function,
    this.outlined = false,
  });

  static const Color _blueFp = Color(0xFF0099af);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: outlined
            ? OutlinedButton(
                onPressed: function,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _blueFp,
                  side: const BorderSide(color: _blueFp),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 18, color: _blueFp),
                ),
              )
            : ElevatedButton(
                onPressed: function,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blueFp,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
      ),
    );
  }
}
