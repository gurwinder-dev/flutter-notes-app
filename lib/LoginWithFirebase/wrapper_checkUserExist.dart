

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/LoginWithFirebase/login_Page.dart';
import 'package:notrepad_free/Screens/home_screen.dart';

class wrapper extends StatefulWidget {
  const wrapper({super.key});

  @override
  State<wrapper> createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  // checkUser() async{
  //   User? user = await FirebaseAuth.instance.currentUser;
  //   if(user!=null){
  //     return HomePage();
  //   }else{
  //     return loginPage();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return loginPage(); // renamed to follow Dart style
          }
        },
      ),
    );
  }
}
