import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:buddymensia/models/user.dart' as user_data;

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  user_data.User? _user;
  user_data.User? get user => _user;

  Future<String?> registration({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      await addAdditionalUserInfo(user!.uid, fullname, email, '', '');

      _user = user_data.User(
          id: user.uid,
          email: email,
          fullname: fullname,
          kodeUnik: '',
          role: 'user');

      notifyListeners();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      final existingUser = await checkUserExistsInDatabase(user!.uid);

      if (!existingUser) {
        await addAdditionalUserInfo(
            user.uid, googleUser!.displayName!, googleUser.email, '', '');
        _user = user_data.User(
            id: user.uid,
            email: googleUser.email,
            fullname: googleUser.displayName,
            kodeUnik: '',
            role: '');
      }

      notifyListeners();

      if (existingUser) {
        return 'Success';
      }

      return 'Success Create';
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = await getUserData();
      notifyListeners();

      return 'Success';
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        return 'User tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        return 'Email atau password salah.';
      } else if (e.code == 'invalid-credential') {
        return 'Email atau password salah.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> changeMode(String role) async {
    try {
      await getCurrentUserReference().update({
        'role': role,
      });

      _user = await getUserData();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateRadius(int radius) async {
    try {
      await getCurrentUserReference().update({
        'radius': radius,
      });

      _user = await getUserData();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateLocation(LatLng location) async {
    try {
      await getCurrentUserReference().update({
        'location': GeoPoint(location.latitude, location.longitude),
      });

      _user = await getUserData();
      notifyListeners();
    } catch (e) {
      print(e);
    }
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
          role: userData['role'],
          radius: userData['radius'],
          location: LatLng(userData['location'].latitude, userData['location'].longitude));
    } else {
      return null;
    }
  }

  Future<void> getUser() async {
    _user = await getUserData();
    notifyListeners();
  }

  DocumentReference getCurrentUserReference() {
    User? user = _auth.currentUser;
    return _firebaseFirestore.collection('users').doc(user!.uid);
  }

  Future<void> addAdditionalUserInfo(String uid, String fullname, String email,
      String kodeUnik, String role) async {
    await _firebaseFirestore.collection('users').doc(uid).set({
      'fullname': fullname,
      'email': email,
      'kodeUnik': kodeUnik,
      'role': role,
      'radius': 100,
      'location': const GeoPoint(-6.315687282015746, 106.79435478845504)
    });
  }

  Future<void> addRoleInfo(user_data.User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set({
      'fullname': user.fullname,
      'email': user.email,
      'kodeUnik': user.kodeUnik,
      'role': user.role
    });

    _user = user;
    notifyListeners();
  }

  Future<String> addKodeUnik(user_data.User user) async {
    bool isUserKodeExist = await userKodeExists(user.kodeUnik!);

    if (!isUserKodeExist) {
      return 'Kode Salah';
    }

    await _firebaseFirestore.collection('users').doc(user.id).set({
      'fullname': user.fullname,
      'email': user.email,
      'kodeUnik': user.kodeUnik,
      'role': user.role
    });

    _user = user;
    notifyListeners();

    return 'Success';
  }

  Future<bool> userKodeExists(String kodeUnik) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Pdr')
          .where('kodeUnik', isEqualTo: kodeUnik)
          .limit(1)
          .get();
      print(querySnapshot.docs);
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isUserLoggedIn() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      _user = await getUserData();
      print(_user!.email);
    }

    notifyListeners();

    return user != null;
  }

  Future<bool> checkUserExistsInDatabase(String userId) async {
    final userDoc =
        await _firebaseFirestore.collection('users').doc(userId).get();
    return userDoc.exists;
  }
}
