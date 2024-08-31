import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final bool isUser;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: isUser ? Colors.teal[100] : Colors.purple[50],
            child: Text(
              comment.author!.fullname![0],
              style: GoogleFonts.montserrat(
                  color: isUser
                      ? AppColors.hijauTuaPrimary
                      : AppColors.unguCaregiver),
            ),
          ),
          title: Text(
            comment.author!.fullname!,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            timeago.format(comment.createdAt!, locale: 'id'),
            style: GoogleFonts.istokWeb(
                fontWeight: FontWeight.w900, fontSize: 16, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            comment.content!,
            style: GoogleFonts.istokWeb(color: Colors.black87, fontSize: 14),
          ),
        ),
        const Divider(color: Colors.black26,)
      ],
    );
  }
}
