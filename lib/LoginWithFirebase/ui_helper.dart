
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class uiHelper{

  static CustomTextField(TextEditingController controller, String text , IconData iconData , bool toHide){
     return  Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
        child: TextField(
          controller: controller,
          obscureText: toHide,
          decoration: InputDecoration(

            hintText: text,
            iconColor: Colors.white,
            prefixIcon: Icon(iconData),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30)
            )
          ),
        ),
      );
  }
  static CustomButton(VoidCallback voidCallback , String text){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton(onPressed: (){
              voidCallback();
            },  style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),  // width, height
            ), child: Text(text,style: TextStyle(fontSize: 16),),
            ),
          );
  }
  static CustomAlertBox(BuildContext context , String text){  
       return showDialog(context: context, builder:(BuildContext context)=>AlertDialog(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(12)
         ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,style: TextStyle(color: Colors.black87,fontSize: 16),),
          ),
         actions: [
           TextButton(onPressed: (){
             Navigator.pop(context);
           },
               child: Text("OK"))
         ],
       ));

  }
  static CustomPasswordTextField(TextEditingController controller, String text ,  bool toHide){
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        height: 60,
        child: TextField(
          controller: controller,
          obscureText: toHide,
          decoration: InputDecoration(

              hintText: text,
              iconColor: Colors.white,
              // border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(1))
              )


        ),
      ),
    );
  }
}