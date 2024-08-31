import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HeaderHomeWidget extends StatelessWidget {
  final String name;
  final String username;
  final bool isUser;
  const HeaderHomeWidget(
      {super.key, required this.name, required this.username, required this.isUser});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Material(
      elevation: 5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.hijauMuda : Colors.purple[50],
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    name[0],
                    style: GoogleFonts.istokWeb(
                        fontSize: 18, color: isUser ? Colors.teal[700] : AppColors.unguCaregiver),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: width * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, $name!',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        username,
                        style: GoogleFonts.istokWeb(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                    backgroundColor: isUser ? Colors.blue[50] : Colors.purple[50],
                    child: Icon(
                      Icons.notifications,
                      color: isUser ? AppColors.hijauTuaPrimary : AppColors.unguCaregiver,
                    )),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width,
                ),
                Text(
                  'Hari ini',
                  style: GoogleFonts.istokWeb(
                      fontWeight: FontWeight.w300, fontSize: 12),
                ),
                Text(
                  getTodayDateInIndonesian(),
                  style: GoogleFonts.istokWeb(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  'Semoga harimu menyenangkan!',
                  style: GoogleFonts.istokWeb(
                      fontWeight: FontWeight.w300, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

String getTodayDateInIndonesian() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('EEEE, d MMMM y', 'id_ID');

  String formattedDate = formatter.format(now);
  return formattedDate;
}
