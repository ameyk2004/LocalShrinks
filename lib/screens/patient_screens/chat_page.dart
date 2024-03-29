import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_shrinks/screens/doctor_screens/patient_graph.dart';
import 'package:local_shrinks/screens/patient_screens/chatbot_screen.dart';
import 'package:local_shrinks/screens/patient_screens/mood_tracking_graph.dart';
import 'package:local_shrinks/utils/colors.dart';

import '../../services/chat_services/chat_service.dart';
import '../../services/firestore services/database.dart';
import '../../utils/widgets/chat_bubble.dart';
import '../../utils/widgets/custom_textfield.dart';
import '../../utils/widgets/widget_support.dart';

class ChatPage extends StatefulWidget {
  final String receiver;
  final String recieverId;
  final String recieverToken;
  const ChatPage({super.key, required this.receiver, required this.recieverId, required this.recieverToken});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  ChatService chatService = ChatService();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController messageController = TextEditingController();
  String userRole = "";
  String name = "";

  Future<void> sendMessageNotification(String message, String recieverName,) async {
    print(widget.recieverToken);
    final body = {
      "to": widget.recieverToken,
      "notification": {
        "title": name,
        "body": message,
      }
    };

    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader:
        "key=AAAA7dQwYeA:APA91bE3CQHPDLBR_iGhoKQIPPph9CUr8VfQP_a64-KAFqVaWvv9-AIw37CVT17X5FxXuhVfBm_5IoWtqFWNzvcm4ObcwkMpJHg7xJXMDxZhytWutPnszcSdRe0xu84YVkCk91Qxameg",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully to user");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
    }
  }

  void sendMessage() async
  {
    if(messageController.text.isNotEmpty)
    {
      await chatService.sendMessage(widget.recieverId, messageController.text, userRole);
      sendMessageNotification(messageController.text, widget.receiver);
      messageController.clear();
    }
  }

  void getUserRole() async
  {
    userRole = (await DatabaseMethods().getUserRole())!;
    name = (await DatabaseMethods().getUserName())!;
    setState(() {

    });
  }

  @override
  void initState() {
    getUserRole();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: deepPurple,
        scrolledUnderElevation: 0.0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.17,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: userRole == "Doctor"
                        ? NetworkImage(
                        "https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg")
                        : NetworkImage(
                        "https://santevitahospital.com/img/vector_design_male_11zon.webp"),
                    radius: MediaQuery.of(context).size.height * 0.055,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.receiver,
                          style: AppWidget.boldTextStyle().copyWith(
                              fontSize: MediaQuery.of(context).size.height * 0.028,
                              color: Colors.white)),

                      // IconButton(onPressed: () {
                      //   sendMessageNotification("Please Recieve the call", name);
                      //   final senderId = auth.currentUser!.uid;
                      //   List<String> userIds = [senderId, widget.recieverId];
                      //   userIds.sort();
                      //   String videoCallId = userIds.join("_");
                      //   Navigator.push(context, MaterialPageRoute(
                      //       builder: (context) =>CallPage(callID: videoCallId)));
                      // }, icon: Icon(Icons.call, color: Colors.white60, size: 30,))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 30),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  print(userRole);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PatientChart(uid: userRole == "Doctor" ? widget.recieverId : auth.currentUser!.uid),
                  ));
                },
                icon: const Icon(Icons.image_search, size: 35, color: Colors.white60,),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20,bottom: 30),
                      child: CustomTextField(
                        hintText: "Message",
                        icon: const Icon(Icons.message_outlined),
                        obscureText: false,
                        textEditingController: messageController,
                      ),
                    ),
                  ),

                  Container(
                      margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: IconButton(icon:const Icon(Icons.send, size: 30,), onPressed: sendMessage,
                      ))],
              ),
            ],
          ),
        ],
      ),




    );
  }

  Widget _buildMessageList() {
    String senderId = auth.currentUser!.uid;
    ScrollController _scrollController = ScrollController();


    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessages(widget.recieverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });


          return ListView(
            controller: _scrollController,
            children: documents.map((doc) => _buildMessageListItem(doc)).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildMessageListItem(DocumentSnapshot doc)
  {
    Map<String, dynamic>data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderId']== auth.currentUser!.uid;
    DateTime time = data['timestamp'].toDate();
    String amPm = DateFormat('a').format(time);
    String timeStamp = "${time.hour}:${time.minute} $amPm";

    final alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: ChatBubble(message: data["message"], isCurrentUser: isCurrentUser, timestamp: timeStamp,));

  }

}

