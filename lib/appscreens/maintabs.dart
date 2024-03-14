import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/profilescreen.dart';
import 'package:shelfobsessed/appscreens/socialscreen.dart';
import 'search.dart';
import '../components/basictabbar.dart';
import 'home.dart';

class TabsScreen extends StatelessWidget{
  final int uid;
  TabsScreen({super.key,required this.uid});
  @override
  Widget build(BuildContext context){
    return TabPane(
          content:[HomeScreen(uid:uid),SearchScreen(uid: uid),Socialscreen(),ProfileScreen(uid: uid)],
      imgname: "bg1.jpg",
      placed: 10,
      tabs: [],);
  }
}