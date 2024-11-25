import 'package:flutter/material.dart';

class SelphIDList extends StatelessWidget
{
  const SelphIDList(this._map, this._heightScreenPercentage, this._widthScreenPercentage, {super.key});

  final Map<String, dynamic>? _map;
  final double _heightScreenPercentage;
  final double _widthScreenPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        children: <Widget>[
          if (_map != null && _map!.length > 1)
            SizedBox(
              height: MediaQuery.of(context).size.height * _heightScreenPercentage,
              width: MediaQuery.of(context).size.width * _widthScreenPercentage,
              child: ListView.builder(
                itemCount: _map!.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = _map!.keys.elementAt(index);
                  return Column(
                    children: <Widget>[
                      ListTile(title: Text(key), subtitle: Text("${_map![key]}")),
                      const Divider(height: 2.0),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}