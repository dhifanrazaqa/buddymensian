import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/jadwal.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/services/jadwal_services.dart';
import 'package:buddymensia/widgets/buttons/primary_btn_widget.dart';
import 'package:buddymensia/widgets/profile/schedule/add_schedule_widget.dart';
import 'package:buddymensia/widgets/profile/schedule/calendar_widget.dart';
import 'package:buddymensia/widgets/profile/schedule/schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool isAdd = true;

  @override
  Widget build(BuildContext context) {
    JadwalServices jadwalProvider = Provider.of<JadwalServices>(context);
    List<Jadwal?> jadwals = jadwalProvider.items;

    AuthService authProvider = Provider.of<AuthService>(context);
    User? user = authProvider.user;

    List<Jadwal?> selectedJadwals = jadwals.where((item) {
      return isSameDate(item!.eventAt!, _selectedDay);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Jadwal Saya',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, fontSize: 14)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarWidget(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                jadwals: jadwals,
                isUser: user!.role == 'user',
                handler: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    
                    if(selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 1)))){
                      isAdd = false;
                    } else {
                      isAdd = true;
                    }
                  });
                  print('Selected date: ${selectedDay.toString()}');
                  print('Selected date: ${focusedDay.toString()}');
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Jadwal Saya',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Column(
                children: selectedJadwals.map((jadwal) {
                  return ScheduleWidget(
                    id: jadwal!.id!,
                    title: jadwal.nama!,
                    time: jadwal.eventAt!,
                    color: jadwal.tipe! == 'Rutinitas'
                        ? const Color(0xFFD298C2)
                        : const Color(0xFF7C93C2),
                    type: jadwal.tipe!,
                    isToday: true,
                    description: jadwal.deskripsi!,
                    isUser: user.role == 'user',
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              !isAdd ? Container() : PrimaryBtnWidget(
                  buttonText: 'Tambah Jadwal',
                  color: user.role == 'user'
                      ? AppColors.hijauTuaSecondary
                      : AppColors.unguCaregiver,
                  handler: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return AddScheduleWidget(
                          selectedDay: _selectedDay,
                          isUser: user.role == 'user',
                        );
                      },
                    );
                    ;
                  })
            ],
          ),
        ),
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
