import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_shrinks/screens/doctor_screens/register_doctor_screen.dart';
import 'package:local_shrinks/services/auth/auth_gate.dart';
import 'package:local_shrinks/utils/colors.dart';
import '../../services/auth/auth_services.dart';
import '../../utils/widgets/custom_textfield.dart';
import '../../utils/widgets/widget_support.dart';
import 'login_page.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void signUp() async {
    AuthService authService = AuthService();

    if (passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fill all Fields"),
        ),
      );
    } else {
      try {
        await authService.signUpWithEmailPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
          name: nameController.text.toString(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registered Successfully"),
          ),
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthWrapper(tutorial: false)));

        // No need to call setState here, as the authentication state change
        // will automatically trigger a rebuild in widgets listening to the authStateChanges stream
      } catch (e) {
        String errorMessage = "An error occurred, please try again later."; // Default error message
        switch (e.toString()) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is invalid.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Error occurred during sign up.';
            break;
          default:
            errorMessage = 'An error occurred while signing up.';
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Hero(
                tag : 'gradient',
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            lightPurple,
                            seaBlue,
                          ])),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Text(""),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image.asset("assets/images/logo.png",
                    //     width: MediaQuery.of(context).size.width/1.3),

                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.center,

                      child: Text("Local Shrinks", style: AppWidget.headlineTextStyle().copyWith(fontSize: 30),),
                    ),
                    SizedBox(height: 20,),
                    Hero(
                      tag: 'LoginSignUp',
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20),
                          height: 500,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("Sign Up", style: AppWidget.headlineTextStyle(),),
                                  SizedBox(height: 30,),
                                  CustomTextField(hintText: "Name", icon: Icon(Icons.person_outline), obscureText: false, textEditingController: nameController, ),
                                  SizedBox(height: 15,),
                                  CustomTextField(hintText: "Email", icon: Icon(Icons.email_outlined), obscureText: false, textEditingController: emailController,),
                                  SizedBox(height: 15,),
                                  CustomTextField(hintText: "Password", icon: Icon(Icons.lock_outlined), obscureText: true, textEditingController: passwordController,),

                                  SizedBox(height: 10,),

                                ],
                              ),


                              Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(20),

                                child: InkWell(
                                  onTap: signUp,
                                  child: Container(

                                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: lightPurple,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text("Sign Up", style: AppWidget.boldTextStyle().copyWith(color: Colors.white,),),

                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 100,),


                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(

                        children: [
                          Text("Aldready Have an Account ?", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                          GestureDetector(
                              onTap: ()
                              {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
                              },
                              child: Text("  Login Now", style: TextStyle(fontSize: 18, color: lightPurple))),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(

                        children: [
                          Text("Are You Doctor ?", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                          GestureDetector(
                              onTap: ()
                              {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DoctorRegistrationPage()));
                              },
                              child: Text("  Register Here", style: TextStyle(fontSize: 18, color: lightPurple))),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
