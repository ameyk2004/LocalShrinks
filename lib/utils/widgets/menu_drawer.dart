import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_shrinks/utils/colors.dart';

import '../../services/auth/auth_services.dart';

class CustomMenuDrawer extends StatefulWidget {
  final String profile_pic;
  final String userName;

  const CustomMenuDrawer({super.key, required this.profile_pic, required this.userName});

  @override
  State<CustomMenuDrawer> createState() => _CustomMenuDrawerState();
}

class _CustomMenuDrawerState extends State<CustomMenuDrawer> {

  File? profile_pic;
  String image_url = "";
  bool Isloading = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;


  void logout() async
  {
    final authService = AuthService();
    try
    {
      authService.logout();
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  void resetPassword()
  {
    FirebaseAuth.instance.sendPasswordResetEmail(email: widget.userName);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(

                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blueAccent,
                            image:  DecorationImage(
                                image: NetworkImage(widget.profile_pic),
                                fit: BoxFit.cover
                            )),

                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.userName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: ListTile(
                      onTap: ()
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Scaffold()));
                      },
                      leading: const Icon(
                        Icons.groups,
                        color: deepPurple,
                      ),
                      title: const Text("T E A M",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListTile(
                      onTap: () async
                      {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.userName);
                      },
                      leading: const Icon(
                        Icons.settings,
                        color: deepPurple,
                      ),
                      title: const Text("P A S S W O R D",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListTile(
              onTap: logout,
              leading: const Icon(
                Icons.logout,
                color: deepPurple,
              ),
              title: const Text("L O G O U T",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
