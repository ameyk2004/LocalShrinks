import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:local_shrinks/utils/colors.dart';
import 'package:local_shrinks/utils/widgets/widget_support.dart';

class PatientChart extends StatefulWidget {
  final String uid;
  const PatientChart({super.key, required this.uid});

  @override
  State<PatientChart> createState() => _PatientChartState();
}

class _PatientChartState extends State<PatientChart> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List moodData = [];
  String name = "";
  Future<void> getMoodData() async
  {

    final snapshot = await firestore.collection("Users").doc(auth.currentUser!.uid).get();
    if(snapshot.exists)
    {
      final moodHistory = await snapshot.data()?["mood_data"] ?? [];
      moodData = moodHistory;
      name = await snapshot.data()?["name"] ?? "";
      print("Mood Data : ${moodData}");
    }

    setState(() {
    });
  }

  @override
  void initState() {
    getMoodData();
    super.initState();
  }

  static Widget leftTitleWidgets(double value, TitleMeta meta) {
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
            FlSpot(1, 4),
            FlSpot(2, 5),
            FlSpot(3, 5),
            FlSpot(4, 4),
            FlSpot(6, 4),
            FlSpot(7, 2),
            FlSpot(8, 3),
            FlSpot(9, 4),
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

  static Widget dailybottomTitleWidgets(double value, TitleMeta meta) {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: deepPurple,
        centerTitle: true,
        title: Text("Patient Graph",style: AppWidget.headlineTextStyle().copyWith(color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Container(
            margin:  EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: seaBlue,
            ),
            height: 400,
              child: Column(
                children: [
                  Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Expanded(
                    child: Container(
                      padding:EdgeInsets.all(20) ,
                      decoration: BoxDecoration(
                        color: Colors.white,
                    
                      ),
                        child: LineChart(dailyData(moodData))),
                  ),
                ],
              ))
        ],
      )
    );
  }
}
