import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:local_shrinks/utils/colors.dart';

import '../../services/details/api_details.dart';
import '../../utils/widgets/chat_bubble.dart';
import '../../utils/widgets/custom_textfield.dart';
import '../../utils/widgets/widget_support.dart';
import 'home_page.dart';



class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  String chatbotResponse = "";
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();



  Future<void> fetchChatHistory() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      List<dynamic> historyFromFirestore =
          snapshot.data()?['chat_bot_history'] ?? [];

      chat_history.addAll(
        historyFromFirestore
            .map((item) {
          Map<String, String> map = {};
          (item as Map<String, dynamic>).forEach((key, value) {
            map[key] = value.toString();
          });
          return map;
        }).toList(),
      );

      setState(() {

      });
    } else {
      // If the document doesn't exist or chat_bot_history is not available, initialize chat_history as an empty list
      chat_history = [];

    }
  }


  @override
  void initState() {
    fetchChatHistory();
    super.initState();
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> chat_history = [];


  TextEditingController textEditingController = TextEditingController();

  Future<void> sendPromptToChatBot(String prompt) async {
    Uri url = Uri.parse("https://techfiesta-web.vercel.app/api/mobile");
    final Timestamp timestamp = Timestamp.now();

    String jsonBody = jsonEncode({'question': prompt, });
    print(prompt);
    _isLoading = true;
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print(response.body);
      final ChatBotData = jsonDecode(response.body);
      print(ChatBotData["content"]);
      chatbotResponse = ChatBotData["content"];

      chat_history.add({
        "prompt": prompt,
        "response": chatbotResponse,
        "timestamp" : timestamp
      });

      String userid = _auth.currentUser!.uid;

      _firestore.collection("Users").doc(userid).update(
          {"chat_bot_history" : chat_history});

      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

      print(chat_history);

      setState(() {_isLoading = false;
      textEditingController.clear();
      });
    } else {
      print(response.statusCode);

    }
  }


  @override
  Widget build(BuildContext context) {


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });


    return Scaffold(
        backgroundColor: backgroundColor,
        appBar:  AppBar(
          backgroundColor: deepPurple,
          scrolledUnderElevation: 0.0,
          toolbarHeight: MediaQuery.of(context).size.height*0.17,
          title: Column(
            children: [
              Align(
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/chatbot.png"),
                  radius: MediaQuery.of(context).size.height*0.055 ,
                ),
              ),
              SizedBox(height: 10,),
              Text("Local Shrinks Chatbot", style: AppWidget.boldTextStyle().copyWith(fontSize: MediaQuery.of(context).size.height*0.028, color: Colors.white))
            ],
          ),
          leading: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new, size: 30),
              )
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  icon: const Icon(Icons.message_outlined, size: 35, color: Colors.white38,),
                ),
              ),
            ),
          ],
        ),

        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 220, 224, 255),
                Color.fromARGB(255, 232, 230, 254)
              ], begin: FractionalOffset(0.5, 0.0), end: FractionalOffset(0.5, 1.0))),
          child: Column(
                children: [
                  Visibility(
                    visible: _isLoading,
                    child: LinearProgressIndicator(
                      color: deepPurple,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chat_history.length,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {

                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: ChatBubble(
                                message: chat_history[index]["prompt"]!,
                                isCurrentUser: true,
                                timestamp: '',
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: ChatBubble(
                                  message: chat_history[index]["response"]!,
                                  isCurrentUser: false,
                                  timestamp: '',
                                )),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 20, bottom: 30),
                          child: CustomTextField(
                            hintText: "Message",
                            icon: Icon(Icons.message_outlined),
                            obscureText: false,
                            textEditingController: textEditingController,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                size: 30,
                              ),
                              onPressed: () {
                                sendPromptToChatBot(
                                    textEditingController.text.toString());
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
        ),
        );
  }
}
