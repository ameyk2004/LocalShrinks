import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{

  Future<Stream<QuerySnapshot>> getUserDetails() async
  {
    return FirebaseFirestore.instance.collection("Users").where("role", isEqualTo: "Patient").snapshots();
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
    return null;
  }

  Future<String> UserRole(User currentUser) async
  {
    String? UserRole = await getUserRole();

    if(UserRole=="Patient")
    {
      print("patient");
      return "Patient";
    }
    else
    {
      return "Doctor";
    }

  }

}