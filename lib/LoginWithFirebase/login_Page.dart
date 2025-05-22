import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/LoginWithFirebase/forgot_Password.dart';
import 'package:notrepad_free/LoginWithFirebase/signUp_Page.dart';
import 'package:notrepad_free/LoginWithFirebase/ui_helper.dart';

import 'package:notrepad_free/Screens/home_screen.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(String email, String password) async {
    if (email.isEmpty && password.isEmpty) {
      return uiHelper.CustomAlertBox(context, "Enter required fields");
    } else {
      UserCredential userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (ex) {
        return uiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          uiHelper.CustomTextField(emailController, 'Email', Icons.mail, false),
          uiHelper.CustomTextField(passwordController, "password", Icons.lock, true),
          Padding(
            padding: const EdgeInsets.only(left: 210),
            child: TextButton(onPressed: (){
               Navigator.push(context,MaterialPageRoute(builder: (context)=>forgotPassword()));
            }, child:Text("Forgot Password")),
          ),


          uiHelper.CustomButton(() {
            login(emailController.text.toString(), passwordController.text.toString());
          },'Login'),

          SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already Have an Account??",style: TextStyle(fontSize: 16),),
              TextButton(onPressed: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>signUpPage()));
              }, child: Text("Sign Up", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
            ]

            ,
          )



        ],
      ),
    );
  }
}
