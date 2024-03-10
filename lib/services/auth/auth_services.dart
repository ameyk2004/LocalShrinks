import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String? getCurrentUserId() {
    return _auth.currentUser!.uid;
  }

  Future<UserCredential> signUpWithEmailPassword(
      {required String email, required String password, required String name}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'image': '',
        'online': true,
        'role': 'Patient',
      });
      print("Online Updated");

      return userCredential;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential> loginEmailPassword(String email,
      String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection("Users").doc(userCredential.user!.uid).update(
          {
            'online': true,
          });
      print("Online Updated");
      return userCredential;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await _firestore.collection("Users").doc(getCurrentUserId()).update({
        'online': false,
      });
      print("Offline Updated");
      return await _auth.signOut();
    } catch (e) {
      throw e.toString();
    }
  }
}
