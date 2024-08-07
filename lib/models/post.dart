import 'package:buddymensia/models/user.dart';

class Post {
  String? id;
  String? judul;
  String? caption;
  DateTime? createdAt;
  String? imageUrl;
  String? userId;
  User author;

  Post({
    this.id,
    this.judul,
    this.caption,
    this.createdAt,
    this.imageUrl,
    this.userId,
    required this.author,
  });  
}