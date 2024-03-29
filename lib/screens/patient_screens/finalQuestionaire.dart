import 'package:flutter/material.dart';
import 'home_page.dart';

class FinalQuestionnaire extends StatefulWidget {
  const FinalQuestionnaire({Key? key}) : super(key: key);

  @override
  _FinalQuestionnaireState createState() => _FinalQuestionnaireState();
}

class _FinalQuestionnaireState extends State<FinalQuestionnaire> {
  List<List<dynamic>> PHQ = [
    ['Little interest or pleasure in doing things', -1],
    ['Feeling down, depressed or hopeless', -1],
    ['Trouble falling asleep, staying asleep, or sleeping too much', -1],
    ['Feeling tired or having little energy', -1],
    ['Poor appetite or overeating', -1],
    [
      'Feeling bad about yourself - or that you’re a failure or have let ourself or your family down',
      -1
    ],
    [
      'Trouble concentrating on things, such as reading the newspaper or watching television',
      -1
    ],
    [
      'Moving or speaking so slowly that other people could have noticed. Or, the opposite - being so fidgety or restless that you have been moving around a lot more than usual',
      -1
    ],
    [
      'Thoughts that you would be better off dead or of hurting yourself in some way',
      -1
    ]
  ];

  List<List<dynamic>> GAD = [
    ['Feeling nervous, anxious, or on edge', -1],
    ['Not being able to stop or control worrying', -1],
    ['Worrying too much about different things', -1],
    ['Trouble relaxing', -1],
    ["Being so restless that it's hard to sit still", -1],
    ['Becoming easily annoyed or irritable', -1],
    ['Feeling afraid as if something awful might happen', -1]
  ];

  int countAnxiety = 0;
  int countDepression = 0;
  int currentQuestionIndex = 0;

  void suggestNextQuestion() {
    if (currentQuestionIndex < PHQ.length) {
      if (PHQ[currentQuestionIndex][1] == -1) {
        // Suggest PHQ question
        setState(() {
          currentQuestionIndex++;
        });
        return;
      }
    } else if (currentQuestionIndex < PHQ.length + GAD.length) {
      if (GAD[currentQuestionIndex - PHQ.length][1] == -1) {
        // Suggest GAD question
        setState(() {
          currentQuestionIndex++;
        });
        return;
      }
    }
    // All questions answered or out of range
    // You can perform any action here, e.g., navigate to the next screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Questionnaire"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentQuestionIndex < PHQ.length)
              QuestionCard(
                question: PHQ[currentQuestionIndex][0],
                index: currentQuestionIndex,
                onUpdateScore: (score) {
                  setState(() {
                    PHQ[currentQuestionIndex][1] = score;
                    suggestNextQuestion();
                  });
                },
              ),
            if (currentQuestionIndex >= PHQ.length)
              QuestionCard(
                question: GAD[currentQuestionIndex - PHQ.length][0],
                index: currentQuestionIndex,
                onUpdateScore: (score) {
                  setState(() {
                    GAD[currentQuestionIndex - PHQ.length][1] = score;
                    suggestNextQuestion();
                  });
                },
              ),
            // Add any other widgets or logic as needed
          ],
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final int index;
  final Function(int) onUpdateScore;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.index,
    required this.onUpdateScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                for (int i = 0; i <= 3; i++)
                  Expanded(
                    child: RadioListTile<int>(
                      title: Text(i.toString()),
                      value: i,
                      groupValue: null,
                      onChanged: (value) {
                        onUpdateScore(value!);
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
