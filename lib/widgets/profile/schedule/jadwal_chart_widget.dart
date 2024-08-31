import 'package:buddymensia/models/jadwal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalChart extends StatelessWidget {
  final List<Jadwal?> jadwalList;

  JadwalChart({required this.jadwalList});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime startRange = today.subtract(const Duration(days: 3));
    DateTime endRange = today.add(const Duration(days: 3));

    Map<DateTime, Map<String, int>> dataPerDay = {};

    jadwalList.forEach((jadwal) {
      DateTime date = DateTime(
          jadwal!.eventAt!.year, jadwal.eventAt!.month, jadwal.eventAt!.day);

      if (date.isAfter(startRange.subtract(const Duration(days: 1))) &&
          date.isBefore(endRange.add(const Duration(days: 1)))) {
        if (!dataPerDay.containsKey(date)) {
          dataPerDay[date] = {'Kegiatan': 0, 'Rutinitas': 0};
        }
        dataPerDay[date]![jadwal.tipe!] = dataPerDay[date]![jadwal.tipe]! + 1;
      }
    });

    List<BarChartGroupData> barGroups = [];

    int index = 0;
    dataPerDay.forEach((date, counts) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: counts['Kegiatan']!.toDouble(),
              color: const Color(0xFF7C93C2),
              width: 15,
            ),
            BarChartRodData(
              toY: counts['Rutinitas']!.toDouble(),
              color: const Color(0xFFD298C2),
              width: 15,
            ),
          ],
        ),
      );
      index++;
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          barGroups: barGroups,
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    DateFormat('d MMM', 'id_ID')
                        .format(dataPerDay.keys.elementAt(value.toInt())),
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      rod.toY.toInt().toString(),
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  })),
        ),
      ),
    );
  }
}
