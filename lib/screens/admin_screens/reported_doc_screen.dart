import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/firestore services/database.dart';
import '../../utils/widgets/widget_support.dart';
import 'doctor_report_thread.dart';

class ReportedDoctorScreen extends StatefulWidget {
  const ReportedDoctorScreen({super.key});

  @override
  State<ReportedDoctorScreen> createState() => _ReportedDoctorScreenState();
}

class _ReportedDoctorScreenState extends State<ReportedDoctorScreen> {

  Stream? reportedDocStream;

  Widget allReportedDoctors()
  {
    return StreamBuilder(stream: reportedDocStream, builder: (context, snapshot)
    {
      if(snapshot.hasData)
      {
        return ListView.separated(
            itemBuilder: (context, index){
              DocumentSnapshot documentSnapshot = snapshot.data.docs[index];

              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorReportsThread(docName: documentSnapshot["name"], doctorId: documentSnapshot["uid"],)));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                          image: NetworkImage(documentSnapshot["image"])),
                    ),
                    title: Text(
                      documentSnapshot["name"],
                      style: AppWidget.boldTextStyle(),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index)
            {
              return SizedBox(height: 10,);
            },
            itemCount: snapshot.data.docs.length);
      }
      return Container();
    });
  }

  getDocStream() async
  {
    reportedDocStream = await DatabaseMethods().getReportedDoctors();
    setState(() {

    });
  }

  @override
  void initState() {
    getDocStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title : Text("Reported Doctors", style: AppWidget.headlineTextStyle(),)
      ),
      body: allReportedDoctors(),
    );
  }
}
