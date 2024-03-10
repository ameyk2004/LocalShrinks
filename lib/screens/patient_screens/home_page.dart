import 'package:flutter/material.dart';
import 'package:local_shrinks/services/auth/auth_services.dart';

import '../../utils/widgets/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello, Shreyas Here",
          style: TextStyle(fontSize: 30),
        ),
      ),
      drawer: CustomMenuDrawer(profile_pic: 'https://p7.hiclipart.com/preview/481/915/760/computer-icons-user-avatar-woman-avatar.jpg', userName: authService.getCurrentUser()!.email!,),
    );
  }
}
