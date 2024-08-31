import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final bool isUser;
  const ProfileHeaderWidget({super.key, required this.name, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: isUser ? Colors.teal[100] : Colors.purple[50],
            child: Text(
              name[0],
              style: GoogleFonts.istokWeb(fontSize: 24, color: isUser ? Colors.teal[700] : AppColors.unguCaregiver),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '"Bahagia itu sederhana"',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Bandung, Indonesia',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
