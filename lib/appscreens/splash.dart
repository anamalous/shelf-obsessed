import 'dart:async';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/sharedpreferencehandler/getprefs.dart';
import 'package:shelfobsessed/sharedpreferencehandler/setprefs.dart';
import 'welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../components/basicbg.dart';
import '../components/textlabel.dart';

class Splash extends StatefulWidget{
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash>{
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),()async{
      var d=await getprefs();
      print("prefs:"+d.toString());
      if(d["loggedin"]==0 || d["loggedin"]==null)
      Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (BuildContext context) => WelcomePage()));
      if(d["loggedin"]==1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (BuildContext context) => TabsScreen(uid:d["uid"])));
      }
    });

  }
  @override
  Widget build(BuildContext context){
    return const BasicBG(imgname:"bg1.jpg",
      align: Alignment.center,
      placed:180,
      content:TextLabel(
        value: "Shelf Care",
        style: FontStyle.normal,
        size: 20,
        col: Colors.white,
      ),
      );
  }
}