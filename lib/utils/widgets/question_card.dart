import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:local_shrinks/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/models/quiz_model.dart';
import 'answer_card.dart';

class QuestionCard extends StatefulWidget {
  QuestionCard({
    super.key,
    required this.questions,
    required this.answers,
    required this.index,
  });

  final List questions;
  final List answers;
  final int index;

  @override
  State<QuestionCard> createState() => _QuestionCardState();

}

class _QuestionCardState extends State<QuestionCard> {
  String selectedAns = "";
  String questionType = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizModel>(
      builder: (BuildContext context, QuizModel quizModel, _) {
        return Container(

          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(widget.questions[widget.index]["question"], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Column(
                  children: [
                    for(int i=0; i<widget.answers.length; i++)
                    InkWell(
                      onTap: ()
                      {
                        questionType = widget.questions[widget.index]["quizType"];
                        selectedAns =  widget.answers[i]["text"];
                        int points = widget.answers[i]["points"];
                        quizModel.addPoints(points, questionType);
                        setState(() {});
                      },
                      child: AnswerWidget(widget: widget, selectedAns: selectedAns, index: i,),
                    ),
                  ]
              )
            ],
          ),
        );
      },
    );
  }
}
