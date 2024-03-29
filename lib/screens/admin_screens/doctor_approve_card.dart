import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_shrinks/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth/auth_services.dart';
import '../../utils/widgets/widget_support.dart';


class DoctorCard extends StatelessWidget {
  String email;
  String name;
  String qualification;
  String experience;
  String location;
  String id;
  String certificateLink;

  AuthService authService = AuthService();



  DoctorCard({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.qualification,
    required this.experience,
    required this.location,
    required this.certificateLink,
  });

  String generateRandomPassword(int length) {
    const String validChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+[]{}|;:,.<>?';

    final Random random = Random();
    StringBuffer password = StringBuffer();

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(validChars.length);
      password.write(validChars[randomIndex]);
    }

    print(password);

    return password.toString();
  }



  approveDoctor(String email, String name, String qualification,
      String location, String experience) async {
    try {
      print("Pending id : $id");

      UserCredential userCredential = await authService.createNewDoctor(
          email, name, qualification, location, experience);
      await authService.loginEmailPassword("admin@localshrinks.in", "Admin1234");
      await FirebaseFirestore.instance.collection("Pending_Approvals")
          .doc(id)
          .delete();


      final uri =
      '''mailto:$email?subject=Approved as Doctor&body=Hello Dr. $name,

      Congratulations! You have been approved to join the Scalp Smart platform.

      Below are your login credentials:
      Email: $email
      Password: ${generateRandomPassword(10)}

      Please keep this information secure. You can use these credentials to log in to the platform.

      Thank you for joining Scalp Smart!

      Best regards,
          The Scalp Smart Team
      ''';
      final url = Uri.parse(uri);
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

    } catch (e) {
      print("Error approving doctor: $e");
    }
  }

  rejectDoctor(String email, String name, String qualification,
      String location, String experience) async {
    try {
      print("Pending id : $id");

      await FirebaseFirestore.instance.collection("Pending_Approvals")
          .doc(id)
          .delete();


      final uri =
      '''mailto:$email?subject=Rejected as Doctor&body=Hello Dr. $name,

     We regret to inform you that your application to join the Scalp Smart platform has been rejected.

     Thank you for your interest, and we appreciate your time and effort in applying.

     If you have any questions or need further clarification, feel free to reach out to us.

     Best regards,
     The Scalp Smart Team
      ''';
      final url = Uri.parse(uri);
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

    } catch (e) {
      print("Error rejecting doctor: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 250,
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://santevitahospital.com/img/vector_design_male_11zon.webp",
                              ),
                              // Assuming _image is a File
                              fit: BoxFit.cover,
                              alignment: Alignment
                                  .topCenter,
                            ),
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        )),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: AppWidget.boldTextStyle(),
                              ),
                              Text(
                                qualification,
                                style: TextStyle(fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text("Exp : $experience",
                                  style: const TextStyle(fontSize: 17)),
                              Text(location, style: const TextStyle(fontSize: 17)),

                              SizedBox(height: 10,),

                              InkWell(
                                  onTap: ()
                                  {
                                    showDialog(context: context, builder: (context)=>AlertDialog(
                                      backgroundColor: seaBlue,
                                      title: Text("Degree Cerificate", style: AppWidget.boldTextStyle(),),
                                      content: Image.network(certificateLink),
                                    ));
                                  },
                                  child: Text("View Certificate", style: AppWidget.lightTextStyle().copyWith(color: deepPurple),))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () async
                          {
                            HapticFeedback.mediumImpact();
                            await rejectDoctor(email, name, qualification,
                                location, experience);
                            showDialog(context: context, builder: (context)=>AlertDialog(
                              title: Text("Doctor Rejected"),
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2 - 50,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: Align(alignment: Alignment.center, child: Text("Reject", style: AppWidget.boldTextStyle().copyWith(fontSize: 17, color: Colors.white),)),
                          )),


                      InkWell(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            await approveDoctor(email, name, qualification,
                                location, experience);
                            showDialog(context: context, builder: (context)=>AlertDialog(
                              title: Text("Doctor Approved"),
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: Align(alignment: Alignment.center, child: Text("Approve", style: AppWidget.boldTextStyle().copyWith(fontSize: 17, color: Colors.white),)),))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
