import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/jadwal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<Jadwal?> jadwals;
  final Function(DateTime, DateTime) handler;
  final bool isUser;
  const CalendarWidget(
      {super.key,
      required this.focusedDay,
      required this.selectedDay,
      required this.handler,
      required this.jadwals,
      required this.isUser});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late Map<DateTime, List<Jadwal?>> events;
  @override
  void initState() {
    super.initState();
    events = _getEventsMap();
  }

  Map<DateTime, List<Jadwal?>> _getEventsMap() {
    Map<DateTime, List<Jadwal?>> map = {};
    for (var jadwal in widget.jadwals) {
      final date = DateTime.utc(
          jadwal!.eventAt!.year, jadwal.eventAt!.month, jadwal.eventAt!.day);
      if (map[date] == null) {
        map[date] = [jadwal];
      } else {
        map[date]!.add(jadwal);
      }
    }
    return map;
  }

  List<Object?> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2024, 12, 31),
              focusedDay: widget.focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(widget.selectedDay, day);
              },
              onDaySelected: widget.handler,
              eventLoader: _getEventsForDay,
              calendarFormat: CalendarFormat.month,
              locale: 'id_ID',
              availableCalendarFormats: const {
                CalendarFormat.month: 'Bulan',
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color:
                      widget.isUser ? AppColors.hijauMuda : Colors.purple[100],
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: widget.isUser
                      ? AppColors.hijauTuaSecondary
                      : AppColors.unguCaregiver,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: _buildMarkers(events.cast<Jadwal>()),
                    );
                  }
                  return null;
                },
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      widget.isUser ? AppColors.hijauMuda : Colors.purple[100],
                  radius: 10,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Hari ini',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  backgroundColor: widget.isUser
                      ? AppColors.hijauTuaSecondary
                      : AppColors.unguCaregiver,
                  radius: 10,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Hari Yang Dipilih',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMarkers(List<Jadwal> events) {
    return Container(
      width: 16.0,
      height: 16.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.isUser ? AppColors.hijauMuda : Colors.purple[100],
      ),
    );
  }
}
