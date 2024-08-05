import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryBtnWidget extends StatelessWidget {
  final String buttonText;
  final Color color;
  final VoidCallback handler;
  const PrimaryBtnWidget(
      {super.key,
      required this.buttonText,
      required this.color,
      required this.handler});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: handler,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.istokWeb(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
