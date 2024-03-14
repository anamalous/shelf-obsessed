import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/pfpwidget.dart';
import 'package:shelfobsessed/components/textlabel.dart';

import '../funcnclass/dimensions.dart';
import '../funcnclass/jsondecode.dart';

class FeedTile extends StatelessWidget {
  final String content;
  final int uid;
  final double w;

  final String querystr = '''query(\$i:Int!){
              userById(uid:\$i){
                       uname
              }
  }
  ''';

  const FeedTile(
      {required this.uid, required this.content,required this.w});

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
                      TextLabel(
                          col: Colors.white,
                          style: FontStyle.normal,
                          size: 20,
                          value: "  "+j["uname"]),
                    ],
                  ),
                      Container(height: d[0]*0.02,),
                      Container(
                        padding: EdgeInsets.fromLTRB(d[0]*0.04, 0, 0, 0),
                        child: TextLabel(
                          col: Colors.white,
                          style: FontStyle.normal,
                          size: 15,
                          value: content),),
                  Container(height: d[0]*0.02,)
                    ],
                  );
            }));
  }
}
