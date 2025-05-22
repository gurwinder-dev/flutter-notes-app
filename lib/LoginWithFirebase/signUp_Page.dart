


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/LoginWithFirebase/login_Page.dart';
import 'package:notrepad_free/LoginWithFirebase/ui_helper.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
   TextEditingController emailController = TextEditingController();
   TextEditingController passwordController = TextEditingController();

    signUp(String email , String password) async{
      if(email.isEmpty && password.isEmpty){
        return uiHelper.CustomAlertBox(context, "Enter required fields");
      }
       UserCredential userCredential;
      try{
       userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>loginPage()));
      } on FirebaseAuthException catch(ex){

         return uiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          uiHelper.CustomTextField(emailController, "Email", Icons.mail,false),
          uiHelper.CustomTextField(passwordController, "Password", Icons.lock, true),
          SizedBox(height: 30,),
          uiHelper.CustomButton(() {
           signUp(emailController.text.toString(), passwordController.text.toString());
          }, "Sign Up")
        ],
      ),
    );
  }
}
