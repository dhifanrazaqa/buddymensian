import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextBtnWidget extends StatelessWidget {
  final String text;
  final VoidCallback handler;
  final Color? color;

  const TextBtnWidget({super.key, required this.text, required this.handler, this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: handler,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.istokWeb(
            color: color ?? AppColors.biruLink,
            fontSize: 14,
            decoration: TextDecoration.underline,
            decorationColor: color ?? AppColors.biruLink,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
