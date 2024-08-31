import 'package:buddymensia/models/user.dart';

class Post {
  String? id;
  String? judul;
  String? caption;
  DateTime? createdAt;
  DateTime? date;
  String? imageUrl;
  String? userId;
  User author;
  List<dynamic>? anggotaKeluarga;
  List<dynamic>? kataMemory;
  int likeCount;
  int commentCount;
  bool? isLiked;

  Post({
    this.id,
    this.judul,
    this.caption,
    this.createdAt,
    this.date,
    this.imageUrl,
    this.userId,
    required this.author,
    this.anggotaKeluarga,
    this.kataMemory,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked
  });  
}