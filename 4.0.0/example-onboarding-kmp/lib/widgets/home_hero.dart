import 'package:flutter/material.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006E80), Color(0xFF00A3B5)],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Identidad', style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 13, letterSpacing: 0.4)),
          SizedBox(height: 6),
          Text('Verifica en un momento', style: TextStyle(color: Colors.white, fontSize: 26, height: 1.15)),
          SizedBox(height: 8),
          Text('Rostro, documento y datos extra, en ese orden.', style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 14, height: 1.35)),
        ],
      ),
    );
  }
}
