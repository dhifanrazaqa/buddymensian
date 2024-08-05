import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialMediaPost extends StatelessWidget {
  final String userName;
  final String timeAgo;
  final String imageUrl;
  final String caption;
  final int likes;
  final int comments;
  final int shares;

  const SocialMediaPost({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.shares,
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
              backgroundColor: Colors.teal[100],
              child: Text(userName[0]),
            ),
            title: Text(
              userName,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              timeAgo,
              style: GoogleFonts.istokWeb(
                  fontWeight: FontWeight.w900, fontSize: 16, color: Colors.grey),
            ),
            trailing: const Icon(Icons.more_vert),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              caption,
              style: GoogleFonts.istokWeb(color: Colors.black87, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconWithCount(Icons.favorite_border, likes),
                _buildIconWithCount(Icons.chat_bubble_outline, comments),
                _buildIconWithCount(Icons.share, shares),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildIconWithCount(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 4),
        Text(count.toString()),
      ],
    );
  }
}
