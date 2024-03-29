import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_shrinks/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/widgets/custom_textfield.dart';
import '../../utils/widgets/widget_support.dart';
import '../patient_screens/login_page.dart';

class DoctorRegistrationPage extends StatefulWidget {

  @override
  State<DoctorRegistrationPage> createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController qualificationContoller = TextEditingController();

  TextEditingController experienceController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isPendingRequest = false;

  Image? _image = null;
  String image_url="";


  _sendMail() async {
    // Android and iOS

    if(!isPendingRequest)
    {
      await createDoctorPendingRequest();
      final uri =
          'mailto:sn2204amey@gmail.com?subject=Doctor Onboarding Request&body=Hello%20Team Local Shrinks\nBelow are my details : \n\nName : ${nameController.text}\nQualification : ${qualificationContoller.text} \nExpirience : ${experienceController.text}\nLocation : ${locationController.text}';
      final url = Uri.parse(uri);
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
    else
    {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Multiple Requests Not Allowed"),
          content: Text("Your request has already been submitted. Please wait for approval before submitting another request."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }

    isPendingRequest = true;


  }

  Future<void> pickImage() async {
    setState(() {});

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print(result.files.single.path!);

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference refDirImages = referenceRoot.child("images");
      Reference RefimageToUpload = refDirImages.child(uniqueFileName);

      try {

        await RefimageToUpload.putFile(file);

        image_url = await RefimageToUpload.getDownloadURL();


      } on Exception catch (e) {

      }
      setState(() {
        print("Image Picked");
        _image = Image.asset("assets/images/tickmark.png");
      });
    } else {
      setState(() {});
    }
  }

  createDoctorPendingRequest() async
  {
    try
    {
      await _firestore.collection("Pending_Approvals").add(
          {
            "name" : nameController.text,
            "qualification" : qualificationContoller.text,
            "experience" : experienceController.text,
            "location" : locationController.text,
            "email" : emailController.text,
            "certificate" : image_url,
          }
      );

      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text("Request Sent Successfully"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ));
    }
    catch(e)
    {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred while submitting the request."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          deepPurple,
                          seaBlue
                        ])),
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
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        height: 650,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Doctor Registration", style: AppWidget.headlineTextStyle(),),
                                SizedBox(height: 30,),


                                CustomTextField(hintText: "Name", icon: Icon(Icons.person_outline), obscureText: false, textEditingController: nameController, ),
                                SizedBox(height: 15,),
                                CustomTextField(hintText: "Email", icon: Icon(Icons.mail), obscureText: false, textEditingController: emailController,),
                                SizedBox(height: 15,),
                                CustomTextField(hintText: "Qualification", icon: Icon(Icons.school_outlined), obscureText: false, textEditingController: qualificationContoller,),
                                SizedBox(height: 15,),
                                CustomTextField(hintText: "Experience", icon: Icon(Icons.work_history_outlined), obscureText: false, textEditingController: experienceController,),
                                SizedBox(height: 15,),
                                CustomTextField(hintText: "Location", icon: Icon(Icons.location_on_outlined), obscureText: false, textEditingController: locationController,),
                                SizedBox(height: 15,),
                                InkWell(
                                  onTap: ()async {
                                    showLoadingScreen(context, "Uploading Certificate", 1000);
                                    await pickImage();
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 60,
                                    padding: EdgeInsets.all(10),

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(width: 1, color: Colors.grey),
                                      color: Color.fromRGBO(238, 237, 235,1),
                                    ),

                                    child: Row(
                                      children: [
                                        Icon(Icons.upload_file_outlined, size: 25,),
                                        SizedBox(width: 10,),
                                        Text("Degree Certificate", style: AppWidget.boldTextStyle(),),
                                        SizedBox(width: 30,),
                                        Visibility(
                                          visible: _image != null,
                                          child: Container(
                                            child: _image,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),


                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),

                              child: InkWell(
                                onTap: _sendMail,
                                child: Container(

                                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: deepPurple,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text("Send Mail", style: AppWidget.boldTextStyle().copyWith(color: Colors.white,),),

                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),



                    Row(

                      children: [

                        Text("Doctor Onboarding Instructions  ", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),

                        GestureDetector(
                            onTap: ()
                            {
                              showModalBottomSheet(context: context, builder: (ctx)=>InstuctionContainer());
                            },
                            child: Container(
                              child: Icon(Icons.info_outline),
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

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
                              child: Text("  Login Now", style: TextStyle(fontSize: 18, color: deepPurple))),
                        ],
                      ),
                    ),

                    SizedBox(height: 50,),




                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLoadingScreen(BuildContext context, String s, int i) {}
}

class InstuctionContainer extends StatelessWidget {
  const InstuctionContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white, // Setting container background color
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.black, // Setting text color
              fontFamily: 'Roboto', // Using Roboto font
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'If you want to register on Local Shrinks, please send us an email at pblgroupproject@gmail.com and provide the following details:',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black, // Setting text color
              fontFamily: 'Roboto', // Using Roboto font
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            '- Degree certificate',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            '- Qualification',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            '- Experience',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            '- Location of clinic',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}