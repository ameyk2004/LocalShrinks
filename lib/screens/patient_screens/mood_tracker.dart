import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mood_tracking_graph.dart';
import 'package:intl/intl.dart';

class MoodData {
  final String emojiPath;

  MoodData({
    required this.emojiPath,
  });
}

class MoodTrackerPage extends StatefulWidget {
  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  int selectedEmojiIndex = 0; // Index of the selected emoji
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> moodData = [];
  
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
    print(moodData);
    getMoodData();
    print(moodData);
    super.initState();
  }

  // List of emoji images and their corresponding descriptions
  List<String> emojiImagePaths = [
    'assets/images/vsad.png', // Replace with actual image paths
    'assets/images/sad.png',
    'assets/images/tired.png',
    'assets/images/happy.png',
    'assets/images/vhappy.png',
    'assets/images/excited.png'
  ];

  List<String> emojiDescriptions = [
    'You are Very Sad',
    'You are Sad',
    'You are Tired',
    'You are Happy',
    'You are Very Happy',
    'You are Excited',
  ];

  // Function to handle emoji selection
  void selectEmoji(int index) {
    setState(() {
      selectedEmojiIndex = index;
    });
  }

  void navigateToMoodStatsPage() {
    MoodData selectedMood = MoodData(
      emojiPath: emojiImagePaths[selectedEmojiIndex],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodStatsPage(moodData: moodData,),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ), // Page background color
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'How are you \n feeling today?',
                style: GoogleFonts.montserrat(
                  color: Color(0xFF180020), // Text color
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                ),
                itemCount: emojiImagePaths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      DateTime now = DateTime.now();
                      int currentTimeInHours = now.second;
                      selectEmoji(index);
                      getMoodData();
                      moodData.add({
                        "mood" : index,
                        "time" : currentTimeInHours,
                      });
                      print(moodData);
                      firestore.collection("Users").doc(auth.currentUser!.uid).update({
                        "mood_data" : moodData,
                      });
                      print("Updated");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MoodStatsPage(moodData: moodData, )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: selectedEmojiIndex == index
                            ? Color(0xFFF7DEFF) // Selected container color
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Image.asset(
                          emojiImagePaths[index],
                          width: 64, // Adjust image size as needed
                          height: 64,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              emojiDescriptions[selectedEmojiIndex],
              style: GoogleFonts.montserrat(
                color: Color(0xFF180020), // Text color
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: navigateToMoodStatsPage,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xFFF7DEFF), // Button color
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Color(0xFF180020), // Text color
                ),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}