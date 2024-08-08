import 'package:buddymensia/models/jadwal.dart';
import 'package:buddymensia/screens/profile/schedule_screen.dart';
import 'package:buddymensia/services/jadwal_services.dart';
import 'package:buddymensia/widgets/buttons/text_btn_widget.dart';
import 'package:buddymensia/widgets/profile/schedule/schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScheduleWidget extends StatelessWidget {
  const ProfileScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    JadwalServices jadwalProvider = Provider.of<JadwalServices>(context);
    List<Jadwal?> jadwals = jadwalProvider.items.take(3).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jadwal',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 13),
              ),
              TextBtnWidget(
                  text: 'Detail',
                  handler: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SchedulePage()),
                    );
                  })
            ],
          ),
          Column(
            children: jadwals.map((jadwal) {
              return ScheduleWidget(
                  title: jadwal!.nama!,
                  time: jadwal.eventAt!,
                  color: jadwal.tipe! == 'Rutinitas'
                      ? const Color(0xFFD298C2)
                      : const Color(0xFF7C93C2),
                  type: jadwal.tipe!,
                  isToday: false,);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
