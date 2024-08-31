import 'dart:io';

import 'package:buddymensia/models/comment.dart';
import 'package:buddymensia/models/like.dart';
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

  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  Post getItemById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  List<Post> getMyPosts() {
    return _items
        .where((item) => item.userId == _auth.currentUser!.uid)
        .toList();
  }

  Post getPostById(String postId) {
    return _items.where((item) => item.id == postId).toList()[0];
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
          .orderBy('createdAt', descending: true)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        int likeCount = await getLikeCount(doc.id);
        int commentCount = await getCommentCount(doc.id);
        bool isLiked = await hasUserLiked(doc.id, _auth.currentUser!.uid);

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
            kataMemory: doc['kataMemory'] ?? [],
            likeCount: likeCount,
            commentCount: commentCount,
            isLiked: isLiked);

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
    DocumentSnapshot documentSnapshot = id == 'default'
        ? await getUserReference().get()
        : await getUserReference(id: id).get();
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

  Future<void> addLike(Like like) async {
    try {
      print(items);
      final postIndex = _items.indexWhere((post) => post.id == like.postId);
      if (postIndex != -1) {
        await _firebaseFirestore.collection('likes').add({
          'userId': _auth.currentUser!.uid,
          'postId': like.postId,
          'createdAt': DateTime.now(),
        });
        _items[postIndex].likeCount += 1;
        _items[postIndex].isLiked = true;
        notifyListeners();
      }
    } catch (e) {
      print('Failed to add like: $e');
    }
  }

  Future<void> deleteLike(Like like) async {
    try {
      final postIndex = _items.indexWhere((post) => post.id == like.postId);
      print(postIndex);
      if (postIndex != -1) {
        final querySnapshot = await _firebaseFirestore
            .collection('likes')
            .where('postId', isEqualTo: like.postId)
            .where('userId', isEqualTo: _auth.currentUser!.uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.delete();
          print('Like deleted successfully.');
        } else {
          print('No like found for the specified userId and postId.');
        }

        _items[postIndex].likeCount -= 1;
        _items[postIndex].isLiked = false;

        notifyListeners();
      }
    } catch (e) {
      print('Failed to add like: $e');
    }
  }

  Future<int> getLikeCount(String postId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('likes')
          .where('postId', isEqualTo: postId)
          .count()
          .get();
      return snapshot.count!;
    } catch (e) {
      print('Failed to get like count: $e');
      return 0;
    }
  }

  Future<bool> hasUserLiked(String postId, String userId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('likes')
          .where('postId', isEqualTo: postId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Failed to check like status: $e');
      return false;
    }
  }

  Future<void> addComment(Comment comment) async {
    final postIndex = _items.indexWhere((post) => post.id == comment.postId);
    if (postIndex != -1) {
      await _firebaseFirestore.collection('comments').add({
        'userId': _auth.currentUser!.uid,
        'postId': comment.postId,
        'content': comment.content,
        'createdAt': DateTime.now(),
      });

      _items[postIndex].commentCount += 1;
      _comments.add(comment);
      notifyListeners();

      fetchComment(comment.postId!);
    }
  }

  Future<int> getCommentCount(String postId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .count()
          .get();
      return snapshot.count!;
    } catch (e) {
      print('Failed to get comment count: $e');
      return 0;
    }
  }

  Future<String> fetchComment(String postId) async {
    try {
      _comments = [];

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('comments')
          .orderBy('createdAt', descending: false)
          .where('postId', isEqualTo: postId)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        

        Comment comment = Comment(
            id: doc.id,
            content: doc['content'] ?? '',
            postId: postId,
            createdAt: (doc['createdAt'] as Timestamp).toDate(),
            userId: doc['userId'] ?? '',
            author: await getUserData(id: doc['userId']) as user_data.User,);

        _comments.add(comment);
      }
      notifyListeners();

      return 'Success';
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
