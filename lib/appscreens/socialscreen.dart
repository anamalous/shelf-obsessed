import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/bookclubs.dart';
import 'package:shelfobsessed/appscreens/peopleprofiles.dart';
import 'package:shelfobsessed/components/basicbg.dart';

import '../funcnclass/dimensions.dart';
import 'authors.dart';

class Socialscreen extends StatelessWidget {
  Socialscreen({super.key});

  @override
  Widget build(BuildContext context) {
    var d=dim(context);
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            toolbarHeight: d[1]*0.01,
            leading: Text(""),
            bottom: TabBar(
              tabs: [
                Tab(text:"People",),
                Tab(text:"Book Clubs"),
                Tab(text:"Authors")
              ],
            ),
          ),
          body: BasicBG(
            imgname: "bg3.jpg",
            placed: 20,
            align: Alignment.center,
            content: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                PeopleProfiles(),
                BookClubs(),
                Authors()
              ],
            ),
          ),
        ));
  }
}
