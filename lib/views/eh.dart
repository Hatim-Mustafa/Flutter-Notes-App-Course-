import 'package:flutter/material.dart';

class Eh extends StatelessWidget {
  const Eh({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust the Column height to its content
        children: [
          Text('First Line'),
          Text('Second Line'),
          Text('Third Line'),
        ],
      ),
    );
  }
}