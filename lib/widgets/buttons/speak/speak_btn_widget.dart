import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';

class SpeakBtnWidget extends StatelessWidget {
  final bool isSpeaking;
  final VoidCallback handler;
  const SpeakBtnWidget({super.key, required this.isSpeaking, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isSpeaking ? Colors.red[800]! : AppColors.hijauTuaSecondary,
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: IconButton.filled(
        padding: const EdgeInsets.all(16),
        style: IconButton.styleFrom(
            backgroundColor: isSpeaking ? Colors.red[800]! : AppColors.hijauTuaSecondary,
            elevation: 2,
            foregroundColor: Colors.black38),
        onPressed: handler,
        icon: isSpeaking ? const Icon(Icons.stop, color: Colors.white, size: 60,) : const Icon(Icons.mic, color: Colors.white, size: 60,)
      ),
    );
  }
}
