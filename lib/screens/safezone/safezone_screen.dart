import 'package:flutter/material.dart';

class SafezoneScreen extends StatelessWidget {
  const SafezoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on,
          size: 100,
          color: Colors.teal,
        ),
        Text(
          'Location Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}