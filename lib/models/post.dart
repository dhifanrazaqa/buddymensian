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
    this.kataMemory
  });  
}