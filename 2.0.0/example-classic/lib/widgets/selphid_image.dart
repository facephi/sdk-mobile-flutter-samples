import 'dart:typed_data';
import 'package:flutter/material.dart';

class SelphIDImage extends StatelessWidget
{
  const SelphIDImage(this._image, this._heightScreenPercentage, this._widthScreenPercentage, {super.key});

  final Uint8List? _image;
  final double _heightScreenPercentage;
  final double _widthScreenPercentage;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget> [
      const Spacer(flex: 1),
      if (_image != null)
        Expanded(
          flex: 9,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * _heightScreenPercentage,
            width: MediaQuery.of(context).size.width * _widthScreenPercentage,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.contain, image: MemoryImage(_image!)),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: Colors.grey[200],
              ),
            ),
          ),
        )
      else
        Expanded (
          flex: 9,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * _heightScreenPercentage,
            width: MediaQuery.of(context).size.width * _widthScreenPercentage,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: Colors.grey[200],
              ),
            )
          ),
        ),
        const Spacer(flex: 1)
      ]
    );
  }
}