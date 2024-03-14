import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/appscreens/addchapterscreen.dart';
import 'package:shelfobsessed/appscreens/showchapters.dart';
import 'package:shelfobsessed/components/basicbg.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/bookclubtile.dart';
import 'package:shelfobsessed/components/nonmemberclubtile.dart';
import 'package:shelfobsessed/components/scrollbg.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/components/datatextbox.dart';
import '../funcnclass/jsondecode.dart';
import '../funcnclass/dimensions.dart';
import '../sharedpreferencehandler/getprefs.dart';
import 'joinclub.dart';
import 'newclub.dart';

class Chapters extends StatefulWidget {
  int uid;
  Chapters({super.key,required this.uid});
  @override
  State<Chapters> createState() => _ChapterState();
}

class _ChapterState extends State<Chapters> {
  var s=TextEditingController();
  String getreq = '''query(\$u:Int!) {
                        allChaps(uid: \$u) {
                            chaps
                        }
                    }''';
  var u;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () async {
      var d = await getprefs();
      setState(() {
        u = d["uid"];
        print(u);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return ScrollBG(imgname: "bg3.jpg",
        content: Column(
      children: [
        Container(
          height: d[0]*0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextLabel(col: Colors.white, style: FontStyle.normal, size: 20, value: "Your Chapters"),
                Container(height: d[1]*0.1,),
                Query(
                    options: QueryOptions(
                        document: gql(getreq), variables: {"u": u}),
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
                Container(height: d[0]*0.05,),
                BasicButton(onpress: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddChapter(uid:u)));
                }, text: "Add New Chapter", w: d[1]*0.5, h: d[0]*0.05)

              ],
            ),
          ),
        ),

      ],
    ),
        placed: 50, align: Alignment.topLeft);
  }
}
