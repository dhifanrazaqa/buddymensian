import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePostsWidget extends StatelessWidget {
  const ProfilePostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Postingan',
            style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildPostingItem('https://picsum.photos/seed/picsum/200/300'),
              _buildPostingItem('https://picsum.photos/seed/picsum/200/300'),
              _buildPostingItem('https://picsum.photos/seed/picsum/200/300'),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildPostingItem(String imageUrl) {
  return Container(
    width: 100,
    height: 100,
    margin: const EdgeInsets.only(left: 16),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      ),
    ),
  );
}
