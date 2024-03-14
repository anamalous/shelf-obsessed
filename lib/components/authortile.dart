import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/appscreens/friendlist.dart';
import 'package:shelfobsessed/appscreens/requests.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/pfpwidget.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../appscreens/AuthorFeed.dart';
import '../funcnclass/dimensions.dart';
import '../funcnclass/jsondecode.dart';

class AuthorTile extends StatelessWidget {
  final String querystr = '''query(\$u:Int!){
              userById(uid:\$u){
                       uname
              }
  }
  ''';
  int uid;
  AuthorTile(
      {required this.uid});

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return TextButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AuthorFeed(uid:uid)));
    }, child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        alignment: Alignment.topLeft,
        width: d[0],
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: Query(
            options:
            QueryOptions(document: gql(querystr), variables: {"u": uid}),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return CircularProgressIndicator();
              }
              var j = jsondec(result.data!['userById'].toString());
              return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PFPWidget(uid: uid, side: d[0] * 0.05),Container(width: 20,),
                    TextLabel(
                        col: Colors.white,
                        style: FontStyle.normal,
                        size: 20,
                        value:j["uname"]),
                  ]);

            })));
  }
}
