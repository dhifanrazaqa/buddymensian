import 'package:buddymensia/models/user.dart';

class Jadwal {
  String? id;
  String? nama;
  String? deskripsi;
  String? tipe;
  DateTime? createdAt;
  DateTime? eventAt;
  String? userId;
  User? author;

  Jadwal({
    this.id,
    this.nama,
    this.deskripsi,
    this.tipe,
    this.createdAt,
    this.eventAt,
    this.userId,
    this.author,
  });  
}