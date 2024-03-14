import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelfobsessed/appscreens/addpostscreen.dart';
import 'package:shelfobsessed/appscreens/friendlist.dart';
import 'package:shelfobsessed/appscreens/profilebooklists.dart';
import 'package:shelfobsessed/appscreens/welcome.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/feedtile.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import '../components/pfpwidget.dart';
import '../components/smallerbutton.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../funcnclass/jsondecode.dart';
import 'chapters.dart';
import 'showchapters.dart';
import 'questions.dart';

import 'editprofile.dart';

class AuthorFeed extends StatefulWidget {
  final int uid;

  AuthorFeed({super.key, required this.uid});

  @override
  State<AuthorFeed> createState() => _AuthorFeedState();
}

class _AuthorFeedState extends State<AuthorFeed> {
  var userquery = '''query(\$u:Int!) {
                    userById(uid:\$u) {
                        uname
                        gen
                        dob
                        bio
                        pid
                        friend
                        read
                        wl
                        isauth
                    }
              }''';
  String getreq = '''query(\$u:Int!) {
                        allChaps(uid: \$u) {
                            chaps
                        }
                    }''';

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return BasicBG(
        align: Alignment.topLeft,
        imgname: "bg3.jpg",
        placed: 40,
        content: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Query(
                  options: QueryOptions(
                    document: gql(userquery),
                    variables: {"u": widget.uid},
                  ),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      print(result.exception.toString());
                      return Text(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return CircularProgressIndicator();
                    }
                    var i = result.data!['userById'];
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PFPWidget(uid: widget.uid, side: d[0] * 0.15),
                              Container(
                                width: d[0] * 0.03,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(height:d[1]*0.1),
                                    TextLabel(
                                      value: i["uname"],
                                      col: Colors.grey.shade200,
                                      style: FontStyle.normal,
                                      size: 30,
                                    ),
                                  ]),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: d[0]*0.9,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(height: 20,),
                                      TextLabel(col: Colors.white, style: FontStyle.normal, size: 20, value: "Chapters Posted:"),
                                      Container(height: d[1]*0.1,),
                                      Query(
                                          options: QueryOptions(
                                              document: gql(getreq), variables: {"u": widget.uid}),
                                          builder: (result, {fetchMore, refetch}) {
                                            if (result.hasException) {
                                              return Text(result.exception.toString());
                                            }
                                            if (result.isLoading) {
                                              return CircularProgressIndicator();
                                            }
                                            var k =
                                            jsondecparam(result.data!['allChaps'].toString(),"chaps");
                                            return Column(
                                              children: [
                                                for(var i in k["chaps"])
                                                  Column(
                                                    children: [
                                                      BasicButton(onpress: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ShowChapter(cname: i.toString().trim(),)));
                                                      },
                                                          text: i, w: d[1]*0.9, h: d[1]*0.2),
                                                      Container(height: 20,)
                                                    ],
                                                  )
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          )

                        ]);
                  },
                ))));
  }
}
