import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../../services/firestore services/database.dart';
import '../../utils/widgets/widget_support.dart';

class DoctorReportsThread extends StatefulWidget {
  final String docName;
  final String doctorId;
  const DoctorReportsThread({super.key, required this.docName, required this.doctorId});

  @override
  State<DoctorReportsThread> createState() => _DoState();
}

class _DoState extends State<DoctorReportsThread> {


  Stream<QuerySnapshot>? reportStream;

  getReportData() async
  {
    reportStream = await DatabaseMethods().getReportOfDoctor(widget.doctorId);
    setState(() {

    });
  }

  @override
  void initState() {
    getReportData();
    super.initState();
  }

  Widget reportThread()
  {
    return StreamBuilder(stream: reportStream, builder: (context, snapshot)
    {
      if(snapshot.hasData)
      {
        return ListView.separated(itemBuilder: (context, index){
          DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
          return ReportObject(name: documentSnapshot["name"], reportDescription: documentSnapshot["report"], date:  documentSnapshot["date"], email: documentSnapshot["reported by"],

          );
        },
            separatorBuilder: (context, index)
            {
              return SizedBox(height: 20,);
            },
            itemCount: snapshot.data!.docs.length);
      }
      else
      {
        return SizedBox(height: 10,);
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.docName, style: AppWidget.headlineTextStyle(),),
        ),
        body: reportThread()

    );
  }
}

class ReportObject extends StatelessWidget {
  final String name;
  final String reportDescription;
  final String date;
  final String email;
  const ReportObject({
    super.key, required this.name, required this.reportDescription, required this.date, required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Color.fromRGBO(241, 239, 239,1)
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage("https://static.vecteezy.com/system/resources/previews/014/489/917/non_2x/man-avatar-icon-flat-vector.jpg"), radius: 22,
              ),
              SizedBox(width: 20,),
              Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)
            ],
          ),
          SizedBox(height: 10,),
          // Text("Subject : Abusive Language", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400)),
          Text(reportDescription),

          SizedBox(height: 10,),

          Text("Submitted on $date, by $email", style: AppWidget.lightTextStyle().copyWith(fontSize: 13),)

        ],
      ),
    );
  }
}

