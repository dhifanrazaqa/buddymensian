import 'package:buddymensia/widgets/buttons/text_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScheduleWidget extends StatelessWidget {
  const ProfileScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jadwal',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 13),
              ),
              TextBtnWidget(text: 'Detail', handler: () {})
            ],
          ),
        ),
        _buildScheduleItem(
            'Sarapan & Latihan otak', '7:30', Colors.blue, 'Kegiatan'),
        _buildScheduleItem(
            'Minum obat (pagi)', '9:00', Colors.pink, 'Rutinitas'),
        _buildScheduleItem(
            'Jalan Pagi di Taman', '10:00', Colors.blue, 'Kegiatan'),
        _buildScheduleItem(
            'Minum Obat (sore)', '17:30', Colors.pink, 'Rutinitas'),
      ],
    );
  }
}

Widget _buildScheduleItem(String title, String time, Color color, String type) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                  SizedBox(
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
          time,
          style:
              GoogleFonts.montserrat(fontWeight: FontWeight.w400, fontSize: 11),
        ),
        const SizedBox(
          width: 8,
        ),
        const Icon(Icons.keyboard_arrow_down),
      ],
    ),
  );
}
