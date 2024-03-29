import 'package:flutter/material.dart';
import 'package:local_shrinks/utils/widgets/question_card.dart';

class NextQuestionPage extends StatefulWidget {
  final List questions;
  final List answers;
  final int index;
  const NextQuestionPage({super.key, required this.questions, required this.answers, required this.index});

  @override
  State<NextQuestionPage> createState() => _NextQuestionPageState();
}

class _NextQuestionPageState extends State<NextQuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: QuestionCard(questions: widget.questions, answers: widget.answers, index: widget.index, )
    );
  }
}
