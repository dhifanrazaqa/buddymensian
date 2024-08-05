import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContainerWidget extends StatelessWidget {
  final String title;
  final String value;
  final double width;
  const ContainerWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 4),
            )
          ],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          color: AppColors.hijauTuaSecondary),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white),
          ),
          Text(
            value,
            style: GoogleFonts.istokWeb(
                fontWeight: FontWeight.w600, fontSize: 30, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
