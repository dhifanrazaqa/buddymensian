import 'package:buddymensia/colors.dart';
import 'package:buddymensia/services/jadwal_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleWidget extends StatefulWidget {
  final String id;
  final String title;
  final DateTime time;
  final Color color;
  final String type;
  final String description;
  final bool isToday;
  final bool isUser;

  const ScheduleWidget(
      {super.key,
      required this.title,
      required this.color,
      required this.type,
      required this.time,
      required this.isToday,
      required this.description,
      required this.isUser,
      required this.id});

  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  bool isExpanded = false;

  void selesai(String id) async {
    JadwalServices jadwalProvider =
        Provider.of<JadwalServices>(context, listen: false);
    await jadwalProvider.deleteData(id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.istokWeb(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: widget.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.type,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.isToday
                      ? DateFormat('HH:mm', 'id_ID').format(widget.time)
                      : DateFormat('d MMMM y', 'id_ID').format(widget.time),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
            if (isExpanded)
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      style: GoogleFonts.montserrat(fontSize: 12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => {selesai(widget.id)},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: widget.isUser
                                    ? AppColors.hijauTuaSecondary
                                    : AppColors.unguCaregiver),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            overlayColor: widget.isUser
                                ? AppColors.hijauTuaSecondary
                                : AppColors.unguCaregiver,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            'Selesai',
                            style: TextStyle(
                              color: widget.isUser
                                  ? AppColors.hijauTuaSecondary
                                  : AppColors.unguCaregiver,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
