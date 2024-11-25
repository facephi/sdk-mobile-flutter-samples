import 'dart:typed_data';
import 'package:flutter/material.dart';

class SelphiImage extends StatelessWidget
{
  const SelphiImage(this._bestImage, {super.key});

  final Uint8List? _bestImage;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget> [
      const Spacer(flex: 1),
      if (_bestImage != null)
        Expanded(
          flex: 8,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover, image: MemoryImage(_bestImage!)),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: Colors.blueGrey[100],
              ),
            ),
          ),
        )
      else
        Expanded (
          flex: 9,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: Colors.blueGrey[100],
              ),
            )
          ),
        ),
        const Spacer(flex: 1)
      ]
    );
  }
}