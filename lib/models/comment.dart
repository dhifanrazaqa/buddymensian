import 'package:buddymensia/models/user.dart';

class Comment {
  final String? id;
  final String? userId;
  final String? postId;
  final String? content;
  final DateTime? createdAt;
  final User? author;

  Comment({
    this.id,
    this.userId,
    this.postId,
    this.content,
    this.createdAt,
    this.author
  });
}