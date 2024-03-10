import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_shrinks/screens/patient_screens/signup_page.dart';

import '../../screens/patient_screens/home_page.dart';
import '../firestore services/database.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
        {

          return FutureBuilder(
            future: DatabaseMethods().UserRole(snapshot.data) ,
            builder: (context, AsyncSnapshot roleSnapshot) {

              if (roleSnapshot.connectionState == ConnectionState.waiting)
              {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: CircularProgressIndicator()),
                );

              }

              else if (roleSnapshot.hasError)
              {
                return Text('Error: ${roleSnapshot.error}');
              }

              else {

                if (roleSnapshot.data == "Patient") {
                  return const HomePage(); // User is a patient
                } else if(roleSnapshot.data == "Doctor"){
                  return const Scaffold();
                }
                else
                {
                  return const Scaffold();
                }
              }
            },
          );

        }

        else {
          return const SignUpPage();
        }
      },
    );
  }
}
