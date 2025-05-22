



import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/DBHelper.dart';
import 'package:notrepad_free/LoginWithFirebase/wrapper_checkUserExist.dart';
import 'package:notrepad_free/LoginWithFirebase/login_Page.dart';
import 'package:notrepad_free/LoginWithFirebase/signUp_Page.dart';
import 'package:notrepad_free/Screens/home_screen.dart';
import 'package:notrepad_free/Screens/splash_screen.dart';
import 'package:notrepad_free/provider/theme_provider.dart';
import 'package:notrepad_free/undo_redo_controller_class.dart';
import 'package:provider/provider.dart';





void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCiv2b97BGwRd8UjvatO8FRR3xV1As04Vk",
        appId: "1:1025497433564:android:fb9ee4a0b56bd002997b19",
        messagingSenderId: "1025497433564",
        projectId:  "flutternote-a03c3")
  );
  runApp(
      MultiProvider(
        providers: [
         ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_)=>UndoRedoController())

            ],
          builder: (context, child)=> MyApp()),
     );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //DBHelper db = DBHelper.getInstance;
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,

            // Set theme based on selected value
            home: SecondScreen(),
          );}
    );


  }

}
