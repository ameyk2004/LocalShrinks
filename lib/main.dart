import 'package:flutter/material.dart';
import 'package:local_shrinks/screens/patient_screens/home_page.dart';
import 'package:local_shrinks/screens/patient_screens/login_page.dart';
import 'package:local_shrinks/screens/patient_screens/questionaire_page.dart';
import 'package:local_shrinks/services/auth/auth_gate.dart';
import 'package:local_shrinks/services/models/quiz_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizModel(),
      child: MaterialApp(
        title: 'Local Shrinks App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(tutorial: false,),
      ),
    );
  }
}
