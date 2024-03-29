import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{

  Future<Stream<QuerySnapshot>> getUserDetails() async
  {
    return FirebaseFirestore.instance.collection("Users").where("role", isEqualTo: "Patient").snapshots();
  }

  Future<String?> getUserName() async{
    String? uid =  getCurrentUserUid();
    if (uid != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid).get();

      if (userSnapshot.exists) {
        String? name = userSnapshot['name'];
        return name;
      }
    }
    return null; // User not found or role not defined
  }

  Future<Stream<QuerySnapshot>> getDoctorDetails() async{
    return FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: "Doctor")
        .snapshots();
  }

  String? getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? uid;

    if (user != null) {
      uid = user.uid;
      print("Current user UID: $uid");
    } else {
      print("No user is currently signed in.");
    }
    return uid;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getPendingRequests()
  async {
    return await FirebaseFirestore.instance.collection("Pending_Approvals").snapshots();
  }

  Future<void> deletePendingDoctor(String uid)
  async {
    await  FirebaseFirestore.instance.collection("Pending_Approvals").doc(uid).delete();
  }

  Future<Stream<QuerySnapshot>> getReportedDoctors() async
  {
    return await FirebaseFirestore.instance.collection("Reported Doctors").snapshots();
  }

  Future<Stream<QuerySnapshot>> getReportOfDoctor(String docId) async
  {
    return await FirebaseFirestore.instance.collection("Reported Doctors").doc(docId).collection("Reports").snapshots();
  }


  Future<String?> getUserRole() async{
    String? uid =  getCurrentUserUid();
    if (uid != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid).get();

      if (userSnapshot.exists) {
        String? role = userSnapshot['role'];
        return role;
      }
    }
    return null; // User not found or role not defined
  }

  Future<String> UserRole(User currentUser) async
  {
    String? UserRole = await getUserRole();

    if(UserRole=="Patient")
    {
      print("patient");
      return "Patient";
    }
    else if (UserRole=="Doctor")
    {
      return "Doctor";
    }
    else
    {
      return "Admin";
    }

  }

}