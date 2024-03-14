import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/bookicon.dart';
import 'package:shelfobsessed/components/pfpwidget.dart';
import 'package:shelfobsessed/components/textlabel.dart';

import '../funcnclass/dimensions.dart';
import '../funcnclass/jsondecode.dart';

class ClubFeedTile extends StatelessWidget {
  final String content;
  final int uid;
  final double w;
  final int bid;

  final String querystr = '''query(\$i:Int!){
              userById(uid:\$i){
                       uname
              }
  }
  ''';
  final bookname = '''query(\$b:Int!){
                        bookById(bid:\$b){
                            bname
                        }
                   }''';

  const ClubFeedTile(
      {required this.uid,
      required this.content,
      required this.w,
      required this.bid});

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
        alignment: Alignment.topLeft,
        width: w,
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: Query(
            options:
                QueryOptions(document: gql(querystr), variables: {"i": uid}),
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
                      PFPWidget(uid: uid, side: d[0] * 0.04),
                      Container(
                        width: d[1]*0.46,
                      child: TextLabel(
                          col: Colors.white,
                          style: FontStyle.normal,
                          size: 22,
                          value: "  " + j["uname"]),),
                      Container(
                        width: d[1]*0.27,
                        alignment: Alignment.centerRight,
                        child: Query(
                          options: QueryOptions(
                              document: gql(bookname), variables: {"b": bid}),
                          builder: (result, {fetchMore, refetch}) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }
                            if (result.isLoading) {
                              return CircularProgressIndicator();
                            }
                            var j = jsondec(result.data!['bookById'].toString());
                            return TextLabel(
                                col: Colors.white,
                                style: FontStyle.normal,
                                size: 11,
                                value: j["bname"]);
                          }),),
                    ],
                  ),
                  Container(
                    height: d[0] * 0.02,
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(d[0] * 0.04, 0, 0, 0),
                    child: TextLabel(
                        col: Colors.white,
                        style: FontStyle.normal,
                        size: 18,
                        value: content),
                  ),
                  Container(
                    height: d[0] * 0.02,
                  )
                ],
              );
            }));
  }
}
