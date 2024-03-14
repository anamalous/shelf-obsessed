import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/pfpwidget.dart';
import 'package:shelfobsessed/components/smallerbutton.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import 'package:shelfobsessed/queries/queryfunc.dart';

import '../appscreens/bookscreen.dart';
import '../funcnclass/dimensions.dart';
import '../funcnclass/jsondecode.dart';
import 'datatextbox.dart';

class ReviewTile extends StatelessWidget {
  final int replying;
  final List replies;
  final String review;
  final int uid;
  final double stars;
  final int curr;
  final int rid, bid;

  final reply = TextEditingController();
  final String querystr = '''query(\$i:Int!){
              userById(uid:\$i){
                       uname
              }
  }
  ''';

  final String revdel = '''mutation(\$r:Int!) {
                            deleteReview(rid:\$r) {
                                  s
                            }
                         }''';

  final revstr = '''mutation (\$b:Int!,\$u:Int!,\$r:String!,\$s:Int!,\$re:Int!){
              reviewReply(bid:\$b,uid:\$u,rev:\$r,st:\$s,rt:\$re) {
                      d
              }
      }''';
  final String revstr2 = '''query(\$i:Int!){
              reviewForId(rid:\$i){
                       replies
              }
  }
  ''';

  final String querystr2 = '''query(\$r:Int!){
              reviewForId(rid:\$r){
                       id
                       uid
                       rev
                       stars
              }
  }''';

  ReviewTile(
      {required this.uid,
      required this.review,
        required this.replies,
      required this.stars,
      required this.curr,
      required this.bid,
      required this.rid,
      required this.replying});

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return Container(
      width: d[1],
      child: TextButton(
        onPressed: (){
          print("replies:"+replies.toString());
      print("rid:"+rid.toString());
      replying==0?showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                contentPadding:
                EdgeInsets.all(0),
                content: Container(
                    padding:
                    EdgeInsets.all(10),
                    color: Colors.black,
                    child:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                        children: [
                      ReviewTile(
                        replies: [],
                        uid: uid,
                        review: review,
                        stars: stars,
                        curr: curr,
                        bid: bid,
                        rid: rid,
                        replying: 2,
                      ),
                          TextLabel(
                            col: Colors.white,
                            style: FontStyle
                                .normal,
                            size: 20,
                            value:
                            "Replies",
                          ),
                          Column(
                        children: [
                          for(var i in replies)
                            ReviewTile(uid: int.parse(i["uid"]), review: i["rev"], replies: [], stars: double.parse(i["stars"]), curr: uid, bid: bid , rid: int.parse(i["id"]), replying: 1)
                        ],
                      )
                    ])));
          }):null;
    },
        child:Column(
          children: [
            Query(
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
                  if (j != null) {
                    return Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        alignment: Alignment.topLeft,
                        width: replying==0?d[1]:d[1]*0.8,
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                        child: Row(
                          children: [
                            replying==1?
                                Icon(Icons.arrow_forward_ios,color: Colors.white,):Container(width: 0,),
                            Container(width: replying==1?d[1]*0.01:0,),
                            PFPWidget(
                                uid: uid,
                                side: replying == 0 ? d[0] * 0.08 : d[0] * 0.06),
                            Container(
                              width: d[1] * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: replying == 0 ? d[1] * 0.6 : d[1] * 0.35,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextLabel(
                                          col: Colors.white,
                                          style: FontStyle.normal,
                                          size: 20,
                                          value: j["uname"]),
                                      replying == 0
                                          ? Row(children: [
                                        TextLabel(
                                            col: Colors.white,
                                            size: 18,
                                            style: FontStyle.normal,
                                            value: stars.toString() + " "),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                      ])
                                          : Container(
                                        height: 0,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: replying==0?d[1] * 0.6:d[1]*0.35,
                                  child:TextLabel(
                                      col: Colors.white,
                                      style: FontStyle.normal,
                                      size: 15,
                                      value: review),),
                                Container(height: d[0]*0.02,),
                                Container(width: replying==0?d[1]*0.6:0,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        replying == 0
                                            ? SmallerButton(
                                            onpress: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                        contentPadding:
                                                        EdgeInsets.all(0),
                                                        content: Container(
                                                            padding:
                                                            EdgeInsets.all(10),
                                                            height: d[0] * 0.35,
                                                            color: Colors.black,
                                                            child:
                                                            Column(children: [
                                                              TextLabel(
                                                                col: Colors.white,
                                                                style: FontStyle
                                                                    .normal,
                                                                size: 20,
                                                                value:
                                                                "Replying to",
                                                              ),
                                                              Container(
                                                                height: d[1] * 0.02,
                                                              ),
                                                              ReviewTile(
                                                                replies: [],
                                                                uid: uid,
                                                                review: review,
                                                                stars: stars,
                                                                curr: curr,
                                                                bid: bid,
                                                                rid: rid,
                                                                replying: 1,
                                                              ),
                                                              Container(
                                                                height: 20,
                                                              ),
                                                              BasicTF(
                                                                  text: "reply",
                                                                  h: d[1] * 0.1,
                                                                  ctrl: reply,
                                                                  w: 0.7,
                                                                  onchange:
                                                                      (value) {},
                                                                  col:
                                                                  Colors.white),
                                                              Container(
                                                                height: d[0] * 0.02,
                                                              ),
                                                              SmallerButton(
                                                                  onpress:
                                                                      () async {
                                                                    if (reply.text
                                                                        .isNotEmpty)
                                                                      var res =
                                                                      await getmutation(
                                                                          {
                                                                            "u":
                                                                            curr,
                                                                            "b":
                                                                            bid,
                                                                            "r": reply
                                                                                .text,
                                                                            "s":
                                                                            stars,
                                                                            "re":
                                                                            rid
                                                                          },
                                                                          revstr,
                                                                          "reviewReply",
                                                                          "d");
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext
                                                                            context) =>
                                                                                BookScreen(
                                                                                    bid: bid)));
                                                                  },
                                                                  text: "Post",
                                                                  w: d[0] * 0.1,
                                                                  h: d[1] * 0.1)
                                                            ])));
                                                  });
                                            },
                                            text: "Reply",
                                            w: d[1] * 0.2,
                                            h: d[0] * 0.04)
                                            : Container(
                                          height: 0,
                                        ),
                                        uid == curr
                                            ? Container(
                                          height: 20,
                                          width: d[1] * 0.2,
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: () async {
                                              var res = await getmutation(
                                                  {"r": rid},
                                                  revdel,
                                                  "deleteReview",
                                                  "s");
                                              if (res == "done")
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                        context) =>
                                                            BookScreen(
                                                                bid: bid)));
                                            },
                                            icon: Icon(Icons.delete,
                                                size: 20, color: Colors.white),
                                          ),
                                        )
                                            : Container(
                                          height: 0,
                                        ),
                                      ]
                                  ),),
                                Container(
                                  height: d[0] * 0.01,
                                ),

                              ],
                            )
                          ],
                        ));
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                }),
          ],
        )
    )
      ,);
  }
}
