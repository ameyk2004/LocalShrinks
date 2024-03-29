import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_shrinks/services/chat_services/push_notifications.dart';

import 'message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String> sendMessage(String recieverId, String message, String recieverName) async {
    final String senderId = _auth.currentUser!.uid!;
    final String senderEmail = _auth.currentUser!.email!;
    final senderToken = await PushNotifications().getToken();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: senderId,
        senderEmail: senderEmail,
        senderToken : senderToken,
        recieverId: recieverId,
        timestamp: timestamp,
        message: message);

    List<String> userIds = [senderId, recieverId];
    userIds.sort();
    String chatRoomId = userIds.join("_");

    DocumentReference messageRef = await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());


    return messageRef.id;
  }

  Stream<QuerySnapshot> getMessages(String userId,String otherId)
  {
    List<String> ids = [userId, otherId];
    ids.sort();
    String chatroomId = ids.join('_');
    return _firestore.collection("chat_rooms").doc(chatroomId).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }


}
