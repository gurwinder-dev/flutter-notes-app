

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/LoginWithFirebase/ui_helper.dart';

class forgotPassword extends StatefulWidget {
   forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  TextEditingController emailController = TextEditingController();

   var email="";

  resetPassword() async{
    setState(() {
      email = emailController.text.trim();
    });
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Password reset e-mail has been sent!")));
      //Future.delayed(Duration(seconds: 2),()=>Navigator.pop(context));
    } on FirebaseAuthException catch(ex){

        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("${ex.code.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password"),),
      body: Column(
         children: [
          SizedBox(height: 15,),
          Text("Reset Link will be sent to your Email Id!",style: TextStyle(fontWeight: FontWeight.bold),),
          uiHelper.CustomTextField(emailController, "enter your email", Icons.email, false),
          SizedBox(height: 10),
          uiHelper.CustomButton(() {
            resetPassword();

          }, "Send Email")
        ],
      ),
    );
  }
}
