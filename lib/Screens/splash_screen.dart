


import 'dart:async';


import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/LoginWithFirebase/wrapper_checkUserExist.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool _a=false, _b=false, _c=false, _d=false, _e=false;
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 400), () => setState(() =>_a=true));
    Timer(Duration(milliseconds: 400), () => setState(() =>_b=true));
    Timer(Duration(milliseconds: 1300),() => setState(() =>_c=true));
    Timer(Duration(milliseconds: 1700),() =>  setState(() =>_e=true));
    Timer(Duration(milliseconds: 3400),() =>  setState(() =>_d=true));
    Timer(Duration(milliseconds: 3850),() => Navigator.of(context).pushReplacement(ThisIsFadeRoute(wrapper())));
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

     double _height = MediaQuery.of(context).size.height;
     double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:const Color(0xFF006E1C),
      body: Column(
        
        children: [
          AnimatedContainer(duration: Duration(milliseconds: _d ? 900: 2500),
            curve: _d ?  Curves.fastLinearToSlowEaseIn : Curves.elasticOut,
          width: 20,
          height: _d ? 0 : _a ? _height/2 : 20,
            //color: const Color(0xFF006E1C),),
          ),
          Center(
            child: AnimatedContainer(duration: Duration(seconds: _d ? 1: _c ? 2: 0),
            curve: Curves.fastLinearToSlowEaseIn,
            height: _d ? _height : _c ? 150 : 20,
            width: _d ? _width : _c ? 200 : 20,
            decoration: BoxDecoration(
              color: _b ? Colors.white : Colors.transparent,

             // shape: _c ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: _d ? BorderRadius.only() : BorderRadius.circular(30)),
            child: Center(
              child: _e ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image.asset("assets/splashn1.png",width: 80,height: 80,),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: AnimatedTextKit(
                      totalRepeatCount: 1,
                      animatedTexts: [
                      FadeAnimatedText("Note",duration: Duration(milliseconds: 1700),
                          textStyle: TextStyle(fontSize: 30,fontWeight: FontWeight.w700,color: Colors.black87)
                      ),
                    
                    ],
                    ),
                  ),
                ],
              )
            : SizedBox()),

            ),
          )
        ],
      ),
    );
  }
}
 class ThisIsFadeRoute extends  PageRouteBuilder{
  final Widget page;

  ThisIsFadeRoute( this.page) : super(
    pageBuilder: (BuildContext context,
    Animation<double>animation,
        Animation<double> anotherAnimation)=>page,
    transitionsBuilder: (BuildContext context,
    Animation<double>animation,
    Animation<double> anotherAnimation,
        Widget child,
    )=>FadeTransition(opacity: animation,
  child: child),
  );
  }

