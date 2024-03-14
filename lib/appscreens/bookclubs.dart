import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/bookclubtile.dart';
import 'package:shelfobsessed/components/nonmemberclubtile.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/components/datatextbox.dart';
import '../funcnclass/jsondecode.dart';
import '../funcnclass/dimensions.dart';
import '../sharedpreferencehandler/getprefs.dart';
import 'joinclub.dart';
import 'newclub.dart';

class BookClubs extends StatefulWidget {
  @override
  State<BookClubs> createState() => _BookClubsState();
}

class _BookClubsState extends State<BookClubs> {
  var s=TextEditingController();
  String getreq = '''query(\$u:Int!) {
                        clubByUid(uid:\$u) {
                            id
                            name
                        }
                    }''';
  String allclubs = '''query(\$u:Int!){
                        allClubs(uid:\$u) {
                            id
                            name
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
    return Column(
      children: [
        Container(
          height: d[0]*0.95,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextLabel(col: Colors.white, style: FontStyle.normal, size: 20, value: "Your Clubs"),
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
                      jsondec(result.data!['clubByUid'].toString());
                      return Column(
                        children: [
                          for(var i in k)
                            BookClubTile(bcid: i["id"], name: i["name"], uid: u)
                        ],
                      );
                    }),
                Container(height: d[0]*0.05,),
                Column(
                  children: [
                    BasicButton(onpress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>NewClub(uid:u)));
                    }, text: "Create New Club", w: d[1]*0.5, h: d[0]*0.05),
                    Container(height: d[0]*0.02,),
                    BasicButton(onpress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>JoinClub()));
                    }, text: "Join Other Clubs", w: d[1]*0.5, h: d[0]*0.05)
                  ],
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
