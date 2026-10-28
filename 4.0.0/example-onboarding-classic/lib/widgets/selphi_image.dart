import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'custom_label.dart';

class SelphiImage extends StatelessWidget
{
  const SelphiImage(this._bestImage, {super.key});

  final Uint8List? _bestImage;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _bestImage != null,
      child: Column(
        children: [
          const CustomLabel(text: "Best Image", color: Color(0xff2196f3)),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _bestImage != null ? MemoryImage(_bestImage!) : const AssetImage('assets/placeholder.png') as ImageProvider,
                      ),
                    ),
                  ),
                ),
              ],
          ),
        ],
      ),
    );
  }
}