import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/jadwal.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/screens/profile/schedule_screen.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/services/jadwal_services.dart';
import 'package:buddymensia/widgets/buttons/text_btn_widget.dart';
import 'package:buddymensia/widgets/profile/schedule/jadwal_chart_widget.dart';
import 'package:buddymensia/widgets/profile/schedule/schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScheduleWidget extends StatelessWidget {
  final bool isUser;
  const ProfileScheduleWidget({super.key, required this.isUser});

  bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    JadwalServices jadwalProvider = Provider.of<JadwalServices>(context);
    List<Jadwal?> jadwals = jadwalProvider.items;
    List<Jadwal?> jadwalsToday = jadwalProvider.getTodayItem();

    AuthService authProvider = Provider.of<AuthService>(context);
    User? user = authProvider.user;

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
                  color: isUser ? AppColors.biruLink : AppColors.unguCaregiver,
                  handler: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SchedulePage()),
                    );
                  })
            ],
          ),
          user!.role! == 'user' || jadwals.isEmpty
              ? Container()
              : SizedBox(height: 150, child: JadwalChart(jadwalList: jadwals)),
          jadwalsToday.isEmpty
              ? Center(child: NoDataWidget())
              : Column(
                  children: jadwalsToday.map((jadwal) {
                    return ScheduleWidget(
                      id: jadwal!.id!,
                      title: jadwal.nama!,
                      time: jadwal.eventAt!,
                      color: jadwal.tipe! == 'Rutinitas'
                          ? const Color(0xFFD298C2)
                          : const Color(0xFF7C93C2),
                      type: jadwal.tipe!,
                      isToday: isToday(jadwal.eventAt!),
                      description: jadwal.deskripsi!,
                      isUser: isUser,
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

Widget NoDataWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/nodata_illustration.png',
        height: 174,
      ),
      Text(
        'Belum Ada Data Yang Ditambahkan',
        style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.hijauTuaSecondary,
        )),
      ),
      Text(
        'Silahkan Tambahkan Data Yang Ditambahkan',
        style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        )),
      ),
    ],
  );
}
