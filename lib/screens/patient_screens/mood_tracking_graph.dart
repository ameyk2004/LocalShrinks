import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
class MoodStatsPage extends StatefulWidget {
  final List moodData;

  const MoodStatsPage({ required this.moodData,});

  @override
  _MoodStatsPageState createState() => _MoodStatsPageState();
}

class _MoodStatsPageState extends State<MoodStatsPage> {

  bool showDailyStats = true;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List moodData = [];

  Future<void> getMoodData() async
  {

    final snapshot = await firestore.collection("Users").doc(auth.currentUser!.uid).get();
    if(snapshot.exists)
    {
      final moodHistory = await snapshot.data()?["mood_data"] ?? [];
      moodData = moodHistory;
      print("Mood Data : ${moodData.length}");
    }

    setState(() {
    });
  }

  @override
  void initState() {
    getMoodData();
    print("Mood Data recieved : ${widget.moodData}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 650,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Mood Stats',
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF180020),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'See your mood throughout the day.',
                    style: GoogleFonts.montserrat(
                      color: Color.fromARGB(171, 24, 0, 32),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 370,
                    child: MoodStatsChart(showDailyStats: showDailyStats, moodData: widget.moodData,),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showDailyStats = true;
                          });
                        },
                        child: Text('Daily'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showDailyStats = false;
                          });
                        },
                        child: Text('Weekly'),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 0,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mood History',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MoodHistoryItem(
                          emojiPath: 'assets/images/happy.png',
                          day: 'Mon',
                        ),
                        MoodHistoryItem(
                          emojiPath: 'assets/images/neutral.png',
                          day: 'Tue',
                        ),
                        MoodHistoryItem(
                          emojiPath: 'assets/images/sad.png',
                          day: 'Wed',
                        ),

                        // Add more MoodHistoryItem widgets for each day
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromRGBO(117, 117, 117, 1),
    fontSize: 12,
  );
  Widget image;
  switch (value.toInt()) {
    case 1:
      image =
          Image.asset('assets/images/vsad.png', width: 30, height: 30);
      break;
    case 2:
      image =
          Image.asset('assets/images/sad.png', width: 30, height: 30);
      break;
    case 3:
      image = Image.asset('assets/images/neutral.png',
          width: 30, height: 30);
      break;
    case 4:
      image =
          Image.asset('assets/images/happy.png', width: 30, height: 30);
      break;
    case 5:
      image =
          Image.asset('assets/images/vhappy.png', width: 30, height: 30);
      break;
    default:
      image = SizedBox(width: 20, height: 20);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: image,
  );
}

Widget dailybottomTitleWidgets(double value, TitleMeta meta) {
  print("value : $value");
  const style = TextStyle(
    color: Color.fromRGBO(117, 117, 117, 1),
    fontSize: 12,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('0:00', style: style);
      break;
    case 4:
      text = const Text('4:00', style: style);
      break;
    case 8:
      text = const Text('8:00', style: style);
      break;
    case 12:
      text = const Text('12:00', style: style);
      break;
    case 16:
      text = const Text('16:00', style: style);
      break;
    case 20:
      text = const Text('20:00', style: style);
      break;
    case 24:
      text = const Text('24:00', style: style);
      break;
    default:
      text = const Text('24:00', style: style);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget weeklybottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromRGBO(117, 117, 117, 1),
    fontSize: 12,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('M', style: style);
      break;
    case 1:
      text = const Text('T', style: style);
      break;
    case 2:
      text = const Text('W', style: style);
      break;
    case 3:
      text = const Text('T', style: style);
      break;
    case 4:
      text = const Text('F', style: style);
      break;
    case 5:
      text = const Text('S', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

class MoodStatsChart extends StatelessWidget {
  final List moodData;
  final bool showDailyStats;
  MoodStatsChart({required this.showDailyStats, required this.moodData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Color(0xFFF7DEFF),
      ),
      child: LineChart(
        showDailyStats ? dailyData(moodData) : weeklyData(),
      ),
    );
  }
}

LineChartData dailyData(List moodData) {
  return LineChartData(
    minX: 0,
    maxX: 24,
    minY: 0,
    maxY: 6,
    titlesData: const FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            // margin: 8,
            interval: 1,

            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 4,
              getTitlesWidget: dailybottomTitleWidgets),
        )),
    gridData: FlGridData(
      show: true,
      horizontalInterval: 1,
      getDrawingVerticalLine: (value) => FlLine(
        color: Color.fromARGB(255, 239, 196, 245),
        strokeWidth: 1,
      ),
      getDrawingHorizontalLine: (value) => FlLine(
        color: Color.fromARGB(255, 239, 196, 245),
        strokeWidth: 1,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border:
      Border.all(color: const Color.fromRGBO(224, 224, 224, 1), width: 1),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: [

          for (int i = 0; i < moodData.length; i++)
            FlSpot(moodData[i]["time"].toDouble(), (moodData[i]["mood"]).toDouble())

        ],
        isCurved: true,
        color: Color.fromARGB(255, 82, 5, 96),
        barWidth: 6,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData:
        BarAreaData(show: true, color: Color.fromARGB(67, 82, 5, 96)),
      ),
    ],
  );
}

LineChartData weeklyData() {
  return LineChartData(
    minX: 0,
    maxX: 6,
    minY: 0,
    maxY: 6,
    titlesData: const FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            // margin: 8,
            interval: 1,

            getTitlesWidget: leftTitleWidgets,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: weeklybottomTitleWidgets),
        )),
    gridData: FlGridData(
      show: true,
      horizontalInterval: 1,
      getDrawingVerticalLine: (value) => FlLine(
        color: Color.fromARGB(255, 239, 196, 245),
        strokeWidth: 1,
      ),
      getDrawingHorizontalLine: (value) => FlLine(
        color: Color.fromARGB(255, 239, 196, 245),
        strokeWidth: 1,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border:
      Border.all(color: const Color.fromRGBO(224, 224, 224, 1), width: 1),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 1), // Mon
          FlSpot(1, 5), // Tue
          FlSpot(2, 3), // Wed
          FlSpot(3, 1), // Thu
          FlSpot(4, 4), // Fri
          FlSpot(5, 3), // Sat
          FlSpot(6, 2), // Sun
        ],
        isCurved: true,
        color: Color.fromARGB(255, 82, 5, 96),
        barWidth: 6,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData:
        BarAreaData(show: true, color: Color.fromARGB(67, 82, 5, 96)),
      ),
    ],
  );
}

class MoodHistoryItem extends StatelessWidget {
  final String emojiPath;
  final String day;

  MoodHistoryItem({
    required this.emojiPath,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset(
            emojiPath,
            width: 40,
            height: 40,
          ),
          SizedBox(height: 5),
          Text(day),
        ],
      ),
    );
  }
}