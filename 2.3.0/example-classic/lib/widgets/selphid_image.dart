import 'dart:convert';
import 'package:flutter/material.dart';
import 'custom_label.dart';

class SelphIDImage extends StatelessWidget
{
  const SelphIDImage(this._text, this._image, this._heightPercentage, this._widthPercentage, {super.key});

  final String _text;
  final String? _image;
  final double _heightPercentage;
  final double _widthPercentage;

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        CustomLabel(text: _text, color: Color(0xff2196f3)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * _heightPercentage,
              width: MediaQuery.of(context).size.width * _widthPercentage,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: MemoryImage(base64Decode(_image!)),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.grey[200],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}