import 'package:flutter/material.dart';

import 'package:local_shrinks/utils/colors.dart';
import 'package:local_shrinks/utils/widgets/question_card.dart';

class AnswerWidget extends StatelessWidget {
  AnswerWidget({
    super.key,
    required this.index,
    required this.widget,
    required this.selectedAns,
  });

  final QuestionCard widget;
  final String selectedAns;
  int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: widget.answers[index]["text"] == selectedAns ? deepPurple : seaBlue.withAlpha(120),
      ),
      child: Text(widget.answers[index]["text"], style: TextStyle(
          color: widget.answers[index]["text"] == selectedAns ? Colors.white : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600
      ),),
    );
  }
}