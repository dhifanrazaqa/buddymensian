import 'dart:io';

import 'package:buddymensia/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:buddymensia/models/user.dart' as user_data;

class PostServices with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<Post> _items = [];

  List<Post> get items => _items;

  Post getItemById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  List<Post> getMyPosts() {
    return _items.where((item) => item.userId == _auth.currentUser!.uid).toList();
  }

  Future<String> uploadData(File image, Post post) async {
    try {
      String fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}.png';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      user_data.User? user = await getUserData();

      await _firebaseFirestore.collection('post').add({
        'judul': post.judul,
        'caption': post.caption,
        'createdAt': post.createdAt,
        'date': post.date,
        'imageUrl': downloadUrl,
        'userId': user!.id,
        'anggotaKeluarga': post.anggotaKeluarga,
        'kataMemory': post.kataMemory
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
          .collection('post')
          .orderBy('date', descending: false)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        Post post = Post(
          id: doc.id,
          judul: doc['judul'] ?? '',
          caption: doc['caption'] ?? '',
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          date: (doc['date'] as Timestamp).toDate(),
          imageUrl: doc['imageUrl'] ?? '',
          userId: doc['userId'] ?? '',
          author: await getUserData(id: doc['userId']) as user_data.User,
          anggotaKeluarga: doc['anggotaKeluarga'] ?? [],
          kataMemory: doc['kataMemory'] ?? []
        );

        _items.add(post);
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
