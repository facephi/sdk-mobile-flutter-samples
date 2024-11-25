import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget
{
  final String text;
  final Function function;

  const CustomButton({super.key,
    required this.text,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () => function(),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xff2196f3),
              //side: BorderSide(color: Color(0xFF764bbb)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
            child: Text(text, style: const TextStyle(fontSize: 20, color: Colors.white, backgroundColor: Color(0xff2196f3)))
        ),
      ),
    );
  }
}