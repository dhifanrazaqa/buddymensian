import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/services/post_services.dart';
import 'package:buddymensia/widgets/profile/post/post_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePostsWidget extends StatelessWidget {
  const ProfilePostsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PostServices postProvider = Provider.of<PostServices>(context);
    List<Post?> posts = postProvider.getMyPosts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Postingan',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: posts.map((post) {
              return PostItemWidget(post: post!);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
