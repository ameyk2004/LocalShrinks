import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../chat_services/push_notifications.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? getCurrentUser() {

    return _auth.currentUser;
  }

  String? getCurrentUserId() {

    return _auth.currentUser!.uid;
  }

  Future<UserCredential> signUpWithEmailPassword({required String email, required String password, required String name}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: "Doctor1234");
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'image' : '',
        'online' : true,
        'deviceToken' : "",
        'role' : 'Patient',
      });
      print("Online Updated");

      return userCredential;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential> loginEmailPassword(String email, String password) async {
    try {
      final deviceToken = await PushNotifications().getToken();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _firestore.collection("Users").doc(userCredential.user!.uid).update({
        'online' : true,
        'deviceToken' : deviceToken,
      });
      FirebaseMessaging.instance.subscribeToTopic("notifications");
      print("Online Updated");
      print(deviceToken);
      return userCredential;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await _firestore.collection("Users").doc(getCurrentUserId()).update({
        'online' : false,
      });
      print("Offline Updated");
      return await _auth.signOut();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential> createNewDoctor(String email, String name, String qualification, String location, String experience) async
  {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: "Doctor1234");
    _firestore.collection("Users").doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
      'name': name,
      'image' : 'https://santevitahospital.com/img/vector_design_male_11zon.webp',
      'qualification' : qualification,
      'location' :location,
      'experience' : experience,
      'online' : false,
      'role' : 'Doctor',
    });
    return userCredential;
  }
}
