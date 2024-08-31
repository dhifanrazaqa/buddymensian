import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/post.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class SocialMediaPost extends StatelessWidget {
  final Post post;
  final bool isUser;
  final bool isLiked;
  final VoidCallback handlerLike;
  final VoidCallback handlerComment;
  final VoidCallback handlerShare;

  const SocialMediaPost({
    super.key,
    required this.post,
    required this.isUser,
    required this.isLiked,
    required this.handlerLike,
    required this.handlerComment,
    required this.handlerShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: isUser ? Colors.teal[100] : Colors.purple[50],
              child: Text(
                post.author.fullname![0],
                style: GoogleFonts.montserrat(
                    color: isUser
                        ? AppColors.hijauTuaPrimary
                        : AppColors.unguCaregiver),
              ),
            ),
            title: Text(
              post.author.fullname!,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              timeago.format(post.createdAt!, locale: 'id'),
              style: GoogleFonts.istokWeb(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.grey),
            ),
            trailing: const Icon(Icons.more_vert),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              post.caption!,
              style: GoogleFonts.istokWeb(color: Colors.black87, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconWithCount(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    post.likeCount.toString(),
                    handlerLike),
                _buildIconWithCount(Icons.chat_bubble_outline,
                    post.commentCount.toString(), handlerComment),
                _buildIconWithCount(Icons.share, '', handlerShare),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildIconWithCount(
      IconData icon, String count, VoidCallback handler) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          overlayColor:
              isUser ? AppColors.hijauTuaSecondary : AppColors.unguCaregiver,
          elevation: 0),
      onPressed: handler,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: icon == Icons.favorite && isLiked ? isUser ? AppColors.hijauTuaSecondary : AppColors.unguCaregiver : Colors.black,
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: GoogleFonts.montserrat(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
