// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class MoodStatsPage extends StatelessWidget {
//   final List<MoodData> moodHistory;

//   MoodStatsPage({required this.moodHistory});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mood Stats'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'See your mood through the day.',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             LineChart(
//               LineChartData(
//                 minX: 0,
//                 maxX: moodHistory.length.toDouble() - 1,
//                 minY: 0,
//                 maxY: 4,
//                 titlesData: FlTitlesData(
//                   bottomTitles: SideTitles(
//                     showTitles: true,
//                     getTitles: (value) {
//                       // Assuming mood history is ordered by time
//                       return moodHistory[value.toInt()].time;
//                     },
//                   ),
//                   leftTitles: SideTitles(
//                     showTitles: true,
//                     getTitles: (value) {
//                       switch (value.toInt()) {
//                         case 0:
//                           return 'Very Sad';
//                         case 1:
//                           return 'Sad';
//                         case 2:
//                           return 'Neutral';
//                         case 3:
//                           return 'Happy';
//                         case 4:
//                           return 'Very Happy';
//                         default:
//                           return '';
//                       }
//                     },
//                   ),
//                 ),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: moodHistory
//                         .asMap()
//                         .entries
//                         .map((entry) => FlSpot(
//                               entry.key.toDouble(),
//                               entry.value.mood.toDouble(),
//                             ))
//                         .toList(),
//                     isCurved: true,
//                     colors: [Colors.grey],
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: FlDotData(show: true),
//                     belowBarData: BarAreaData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Mood History',
//               style: TextStyle(fontSize: 20),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: moodHistory.length,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           moodHistory[index].emojiPath,
//                           width: 40,
//                           height: 40,
//                         ),
//                         Text(moodHistory[index].time),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MoodData {
//   final String time;
//   final int mood;
//   final String emojiPath;

//   MoodData({
//     required this.time,
//     required this.mood,
//     required this.emojiPath,
//   });
// }
