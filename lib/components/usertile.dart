import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/appscreens/requests.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/pfpwidget.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';

import '../funcnclass/dimensions.dart';
import '../funcnclass/jsondecode.dart';

class UserTile extends StatelessWidget {
  final int send,curr;

  final String querystr = '''query(\$i:Int!){
              userById(uid:\$i){
                       uname
              }
  }
  ''';

  final String accreq='''mutation(\$s:Int!,\$a:Int!) {
                              acceptRequest(send:\$s,acc:\$a){
                                s
                              }
                            }''';
  final String delreq='''mutation(\$s:Int!,\$d:Int!) {
                              deleteRequest(send:\$s,dele:\$d){
                                      s
                               }
                        }''';

  const UserTile(
      {required this.send,required this.curr});

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        alignment: Alignment.topLeft,
        width: d[0],
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: Query(
            options:
            QueryOptions(document: gql(querystr), variables: {"i": send}),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return CircularProgressIndicator();
              }
              var j = jsondec(result.data!['userById'].toString());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PFPWidget(uid: send, side: d[0] * 0.09),
                      Container(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [TextLabel(
                            col: Colors.white,
                            style: FontStyle.normal,
                            size: 20,
                            value: "  "+j["uname"]),
                      Container(height: 20,),
                      Row(
                        children: [
                          BasicButton(onpress: ()async{
                            var res=await getmutation({"s":send,"a":curr}, accreq, "acceptRequest", "s");
                            print(res);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Added"),
                              duration: Duration(milliseconds: 500),
                            ));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Requests(uid: curr)));
                            },
                              text: "accept", w: d[1]*0.3, h: d[0]*0.05),
                          Container(width: 20,),
                          BasicButton(onpress: ()async{
                            var res= await getmutation({"s":send,"d":curr}, delreq, "deleteRequest", "s");
                            print(res);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Removed"),
                              duration: Duration(milliseconds: 500),
                            ));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Requests(uid: curr)));
                          }, text: "delete", w: d[1]*0.3, h: d[0]*0.05)
                        ],
                      )
              ],)
                    ],
                  ),

                ],
              );
            }));
  }
}
