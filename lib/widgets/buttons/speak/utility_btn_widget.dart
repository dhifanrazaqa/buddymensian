import 'package:flutter/material.dart';

class UtilityBtnWidget extends StatelessWidget {
  final String image;
  final double scale;
  final VoidCallback handler;
  const UtilityBtnWidget({super.key, required this.image, required this.scale, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: IconButton.filled(
        padding: const EdgeInsets.all(16),
        style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFD9D9D9),
            elevation: 2,
            foregroundColor: Colors.black38),
        onPressed: handler,
        icon: Image.asset(
          image,
          scale: scale,
        ),
      ),
    );
  }
}
