import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  String? id;
  String? fullname;
  String? email;
  String? role;
  String? kodeUnik;
  String? imageUrl;
  int? radius;
  LatLng? location;

  User({
    this.id,
    this.fullname,
    this.email,
    this.role,
    this.kodeUnik,
    this.imageUrl,
    this.radius,
    this.location
  });  
}