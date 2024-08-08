import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ScheduleWidget extends StatelessWidget {
  final String title;
  final DateTime time;
  final Color color;
  final String type;
  final bool isToday;
  const ScheduleWidget(
      {super.key,
      required this.title,
      required this.color,
      required this.type,
      required this.time,
      required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.istokWeb(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      type,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            isToday ? DateFormat('HH:mm', 'id_ID').format(time) : DateFormat('d MMMM y', 'id_ID').format(time),
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400, fontSize: 11),
          ),
          const SizedBox(
            width: 8,
          ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
