import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_shrinks/screens/patient_screens/chatbot_screen.dart';
import 'package:local_shrinks/services/auth/auth_services.dart';

import '../../utils/colors.dart';
import '../../utils/widgets/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjusting sizes based on screen dimensions
    double buttonWidth = screenWidth * 0.4; // 40% of screen width
    double buttonHeight = screenHeight * 0.10; // 12% of screen height
    double imageSize = screenWidth * 0.50; // 45% of screen width for the image
    double padding = screenWidth * 0.05; // 5% of screen width for padding

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 220, 224, 255),
              Color.fromARGB(255, 232, 230, 254)
            ], begin: FractionalOffset(0.5, 0.0), end: FractionalOffset(0.5, 1.0))),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: SingleChildScrollView(
              // Allows for vertical scrolling
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                    EdgeInsets.all(30), // Padding around the outer circle
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white54, // Border color
                        width: 2, // Border width
                      ),
                    ),
                    child: Container(
                      color: Colors
                          .transparent, // Ensures the inside of the circle is transparent
                      child: Image.asset(
                        'assets/images/kitty.png',
                        width: imageSize, // Dynamically sized image width
                        // height: imageSize, // Dynamically sized image height
                        fit: BoxFit.cover, // Adjust the image scaling
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatBotPage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffb7862D7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          width: buttonWidth, // Dynamically sized button width
                          height:
                          buttonHeight, // Dynamically sized button height
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: const Text(
                              'Chatbot',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffb7862D7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          width: buttonWidth, // Dynamically sized button width
                          height:
                          buttonHeight, // Dynamically sized button height
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: const Text(
                              'Mood Tracking',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffb7862D7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          width: buttonWidth, // Dynamically sized button width
                          height:
                          buttonHeight, // Dynamically sized button height
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: const Text(
                              'Survey',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffb7862D7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          width: buttonWidth, // Dynamically sized button width
                          height:
                          buttonHeight, // Dynamically sized button height
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: const Text(
                              'Therapists',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  const Text(
                    'How can I help you today?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: CustomMenuDrawer(
        profile_pic:
        'https://p7.hiclipart.com/preview/481/915/760/computer-icons-user-avatar-woman-avatar.jpg',
        userName: authService.getCurrentUser()!.email!,
      ),
    );
  }
}