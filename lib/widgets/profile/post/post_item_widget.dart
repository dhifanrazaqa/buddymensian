import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/screens/home/speak_screen.dart';
import 'package:flutter/material.dart';

class PostItemWidget extends StatelessWidget {
  final Post post;
  const PostItemWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SpeakScreen(
                  post: post,
                )));
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(post.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
