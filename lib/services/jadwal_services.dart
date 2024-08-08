import 'package:buddymensia/models/jadwal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buddymensia/models/user.dart' as user_data;

class JadwalServices with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<Jadwal> _items = [];

  List<Jadwal> get items => _items;

  Jadwal getItemById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<String> uploadData(Jadwal jadwal) async {
    try {
      await _firebaseFirestore.collection('jadwal').add({
        'nama': jadwal.nama,
        'deskripsi': jadwal.deskripsi,
        'tipe': jadwal.tipe,
        'createdAt': jadwal.createdAt,
        'eventAt': jadwal.eventAt,
        'userId': _auth.currentUser!.uid,
      });

      fetchData();
      notifyListeners();

      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> fetchData() async {
    try {
      _items = [];

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('jadwal')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .orderBy('createdAt', descending: false)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        Jadwal jadwal = Jadwal(
          id: doc.id,
          nama: doc['nama'] ?? '',
          deskripsi: doc['deskripsi'] ?? '',
          tipe: doc['tipe'] ?? '',
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          eventAt: (doc['eventAt'] as Timestamp).toDate(),
        );

        _items.add(jadwal);
      }
      notifyListeners();

      return 'Success';
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  DocumentReference getUserReference({String id = 'default'}) {
    if (id == 'default') {
      User? user = _auth.currentUser;
      return _firebaseFirestore.collection('users').doc(user!.uid);
    }
      return _firebaseFirestore.collection('users').doc(id);
  }

  Future<user_data.User?> getUserData({String id = 'default'}) async {
    DocumentSnapshot documentSnapshot = id == 'default' ? await getUserReference().get() : await getUserReference(id: id).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;
      return user_data.User(
          id: _auth.currentUser!.uid,
          email: userData['email'],
          fullname: userData['fullname'],
          kodeUnik: userData['kodeUnik'],
          role: userData['role']);
    } else {
      return null;
    }
  }
}
