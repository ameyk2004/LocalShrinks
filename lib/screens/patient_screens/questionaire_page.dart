import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:local_shrinks/services/details/questions.dart';
import 'package:provider/provider.dart';

import '../../services/models/quiz_model.dart';
import '../../utils/colors.dart';
import '../../utils/widgets/question_card.dart';
import '../../utils/widgets/widget_support.dart';
import 'home_page.dart';


class QuestionairePage extends StatefulWidget {
  @override
  _QuestionairePageState createState() => _QuestionairePageState();
}
class _QuestionairePageState extends State<QuestionairePage> {

  late Map<String, dynamic> quizData;
  late String quizName;
  late List<dynamic> questions;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    quizData = jsonQuizData;
    quizName = quizData['quiz_name'];
    questions = quizData['questions'];

    // Reset the total points to zero when the page is loaded
    Provider.of<QuizModel>(context, listen: false).setZero();
  }


  void submitForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Complete'),
          content: Consumer<QuizModel>(
            builder: (context, quizmodel, _) {

              firestore.collection("Users").doc(auth.currentUser!.uid).update({
                "form results": {
                  "anxiety": quizmodel.showGADPoints(),
                  "phq": quizmodel.showPHQPoints(),
                }
              });

              return Text("Score Sent Successfully");
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: deepPurple,
        scrolledUnderElevation: 0.0,
        toolbarHeight: MediaQuery.of(context).size.height*0.17,
        title: Column(
          children: [
            Align(
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/question-aire.jpg"),
                radius: MediaQuery.of(context).size.height*0.055 ,
              ),
            ),
            SizedBox(height: 10,),
            Text("Menatl Health Quiz", style: AppWidget.boldTextStyle().copyWith(fontSize: MediaQuery.of(context).size.height*0.028, color: Colors.white))
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

      body: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,),
              child: Text("Over the last 2 weeks, how often have you been bothered by the following problems ?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),)),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.separated(
              itemCount: questions.length,
                itemBuilder: (context, index)
            {
              List answers = questions[index]['answers'] as List<dynamic>;
              return QuestionCard(questions: questions, answers: answers, index : index);
            }, separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 20,);
            },
            ),
          ),
          // Expanded(
          //   child: ListView(
          //     children: [
          //       QuestionCard(questions: questions, answers: questions[16]['answers'], index: 0)
          //     ],
          //   ),
          // )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: submitForm,
        child: Icon(Icons.check_circle_outline),
      ),
    );
  }
}

