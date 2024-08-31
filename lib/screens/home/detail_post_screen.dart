import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/comment.dart';
import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/services/post_services.dart';
import 'package:buddymensia/widgets/homepage/comment_widget.dart';
import 'package:buddymensia/widgets/textfields/general_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailPostScreen extends StatefulWidget {
  final Post post;
  final bool isUser;
  final bool isLiked;
  final VoidCallback handlerLike;
  final VoidCallback handlerShare;

  const DetailPostScreen(
      {super.key,
      required this.post,
      required this.isUser,
      required this.isLiked,
      required this.handlerLike,
      required this.handlerShare});

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  late final PostServices postProvider;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostServices>(context, listen: false);
  }

  void sendComment(String content) async {
    await postProvider
        .addComment(Comment(content: content, postId: widget.post.id));

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          widget.isUser ? Colors.teal[100] : Colors.purple[50],
                      child: Text(
                        widget.post.author.fullname![0],
                        style: GoogleFonts.montserrat(
                            color: widget.isUser
                                ? AppColors.hijauTuaPrimary
                                : AppColors.unguCaregiver),
                      ),
                    ),
                    title: Text(
                      widget.post.author.fullname!,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      timeago.format(widget.post.createdAt!, locale: 'id'),
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
                        widget.post.imageUrl!,
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.post.caption!,
                      style: GoogleFonts.istokWeb(
                          color: Colors.black87, fontSize: 14),
                    ),
                  ),
                  const Divider(
                    color: Colors.black26,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Consumer<PostServices>(
                        builder: (context, postProvider, child) {
                      final post = postProvider.getItemById(widget.post.id!);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildIconWithCount(
                              post.isLiked!
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              post.likeCount.toString(),
                              widget.handlerLike),
                          _buildIconWithCount(Icons.chat_bubble_outline,
                              post.commentCount.toString(), () {}),
                          _buildIconWithCount(
                              Icons.share, '', widget.handlerShare),
                        ],
                      );
                    }),
                  ),
                ],
              ),
              const Divider(
                color: Colors.black12,
              ),
              Consumer<PostServices>(
                builder: (context, postProvider, child) {
                  final comments = postProvider.comments;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return CommentWidget(
                          comment: comments[index], isUser: widget.isUser);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: GeneralTextfieldWidget(
                      labelText: 'Komen',
                      hintText: 'Masukkan Komentar',
                      inputType: TextInputType.name,
                      isRequired: false,
                      controller: _commentController,
                      icon: Icons.subtitles,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: widget.isUser
                        ? AppColors.hijauTuaSecondary
                        : AppColors.unguCaregiver,
                  ),
                  onPressed: () async {
                    sendComment(_commentController.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithCount(
      IconData icon, String count, VoidCallback handler) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          overlayColor: widget.isUser
              ? AppColors.hijauTuaSecondary
              : AppColors.unguCaregiver,
          elevation: 0),
      onPressed: handler,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: icon == Icons.favorite && widget.isLiked
                ? widget.isUser
                    ? AppColors.hijauTuaSecondary
                    : AppColors.unguCaregiver
                : Colors.black,
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
