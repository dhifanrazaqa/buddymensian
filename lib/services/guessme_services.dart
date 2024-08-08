import 'dart:io';
import 'package:buddymensia/models/guess_me.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:buddymensia/models/user.dart' as user_data;

class GuessMeService with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<GuessMe> _items = [];

  List<GuessMe> get items => _items;

  GuessMe getItemById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<String> uploadData(File image, GuessMe guessMe) async {
    try {
      String fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}.png';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      user_data.User? user = await getUserData();

      // Simpan data ke Firestore
      await _firebaseFirestore.collection('guessme').add({
        'nama': guessMe.nama,
        'status': guessMe.status,
        'kota': guessMe.kota,
        'date': guessMe.date,
        'imageUrl': downloadUrl,
        'userId': user!.id,
        'kodeUnik': user.kodeUnik,
        'additionalInfo': guessMe.additionalInfo
      });

      fetchData();
      notifyListeners();

      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  String getFileNameFromUrl(String url) {
    List<String> pathComponents = Uri.parse(url).pathSegments;
    String fileName = path.basename(pathComponents.last);
    return fileName;
  }

  Future<File> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_image.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> updateData(
      String id,
      String oldImage,
      bool isImageChanged,
      File newImage,
      String nama,
      String status,
      String kota,
      DateTime date,
      Map<String, dynamic> additionalInfo) async {
    try {
      String downloadUrl = '';

      if (isImageChanged) {
        String name = getFileNameFromUrl(oldImage);
        String fileName = 'uploads/$name';
        UploadTask uploadTask =
            _storage.ref().child(fileName).putFile(newImage);
        TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      } else {
        downloadUrl = oldImage;
      }
      user_data.User? user = await getUserData();

      await _firebaseFirestore.collection('guessme').doc(id).update({
        'nama': nama,
        'status': status,
        'kota': kota,
        'date': date,
        'imageUrl': downloadUrl,
        'userId': user!.id,
        'kodeUnik': user.kodeUnik,
        'additionalInfo': additionalInfo
      });

      int index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index] = GuessMe(
            id: id,
            nama: nama,
            kota: kota,
            date: date,
            status: status,
            imageUrl: downloadUrl,
            userId: user.id,
            kodeUnik: user.kodeUnik,
            additionalInfo: additionalInfo);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteData(String id, String imageUrl) async {
    try {
      Reference storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();

      await _firebaseFirestore.collection('guessme').doc(id).delete();

      _items.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String> fetchData() async {
    try {
      _items = [];
      // user_data.User? user = await getUserData();
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('guessme')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .orderBy('date', descending: false)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        GuessMe guessMe = GuessMe(
          id: doc.id,
          nama: doc['nama'] ?? '',
          status: doc['status'] ?? '',
          kota: doc['kota'] ?? '',
          date: (doc['date'] as Timestamp).toDate(),
          imageUrl: doc['imageUrl'] ?? '',
          userId: doc['userId'] ?? '',
          kodeUnik: doc['kodeUnik'] ?? '',
          additionalInfo: doc['additionalInfo'] ?? {},
        );

        _items.add(guessMe);
      }
      notifyListeners();

      return 'Success';
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  DocumentReference getCurrentUserReference() {
    User? user = _auth.currentUser;
    return _firebaseFirestore.collection('users').doc(user!.uid);
  }

  Future<user_data.User?> getUserData() async {
    DocumentSnapshot documentSnapshot = await getCurrentUserReference().get();
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