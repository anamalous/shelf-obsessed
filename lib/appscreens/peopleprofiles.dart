import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/appscreens/questions.dart';
import 'package:shelfobsessed/appscreens/requests.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import 'package:swipe_cards/draggable_card.dart';

import '../funcnclass/dimensions.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../funcnclass/jsondecode.dart';
import '../sharedpreferencehandler/getprefs.dart';

class PeopleProfiles extends StatefulWidget {
  PeopleProfiles({super.key});

  @override
  State<PeopleProfiles> createState() => _PeopleState();
}

class _PeopleState extends State<PeopleProfiles> {
  MatchEngine? _matchEngine;

  String profquery = '''query(\$u:Int!) {
                        profByUid(uid:\$u)
                      }
              ''';

  String suggquery = '''query(\$u:Int!){
                            suggestedProfiles(uid:\$u) {
                                    id
                                    uname
                                    pid
                                    bio
                            }
                        }''';
  String ansyet = '''query(\$u:Int!){
                        userById(uid:\$u) {
                              ans
                        }
                      }''';
  String reqmut = '''mutation(\$se:Int!,\$r:Int!) {
                       sendRequest(send:\$se,rec:\$r){
                          s
                        }
                    }''';

  String acceptmut = '''mutation {
                          acceptRequest(send:1,acc:18){
                                s
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          alignment: Alignment.centerLeft,
          height: d[0] * 0.07,
          width: d[1] * 0.9,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Requests(uid: u)));
                },
                child: TextLabel(
                  col: Colors.white,
                  style: FontStyle.normal,
                  size: 20,
                  value: "Your Requests",
                ),
              ),
              Icon(
                Icons.heart_broken,
                color: Colors.white,
              ),
            ],
          )),
      Container(
        height: d[0] * 0.02,
      ),
      TextLabel(
          col: Colors.white,
          style: FontStyle.normal,
          size: 20,
          value: "Your Matches"),
      Container(
        height: 10,
      ),
      Query(
          options: QueryOptions(document: gql(ansyet), variables: {"u": u}),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception!.linkException.toString());
            }
            if (result.isLoading) {
              return CircularProgressIndicator();
            }
            var res = jsondecparam(result.data!['userById'].toString(),"ans");
            if (res["ans"].toString()=="[ul]") {
              return Column(
                children: [
                  Container(height: d[0]*0.2,),
                  TextLabel(col: Colors.white, style: FontStyle.italic, size: 20, value: "We don't know you so well yet:("),
                  Container(height: d[0]*0.03,),
                  BasicButton(
                  onpress: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => Questions(uid: u)));
              },
            text: "Tell Us More About You",
            w: d[1] * 0.8,
            h: d[0] * 0.06)
                ],
              );
            }
            else {
              return Container(
                  height: d[0] * 0.6,
                  width: d[1] * 0.8,
                  child: Query(
                      options: QueryOptions(
                          document: gql(suggquery), variables: {"u": u}),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return Text(result.exception.toString());
                        }
                        if (result.isLoading) {
                          return CircularProgressIndicator();
                        }
                        var k = jsondec(
                            result.data!['suggestedProfiles'].toString());
                        print(k);
                        List<SwipeItem> _swipeItems = <SwipeItem>[];
                          for (var item in k) {
                            _swipeItems.add(SwipeItem(
                                content: Column(
                                  children: [
                                    Query(
                                        options: QueryOptions(
                                            document: gql(profquery),
                                            variables: {
                                              "u": int.parse(item["id"])
                                            }),
                                        builder: (result,
                                            {fetchMore, refetch}) {
                                          if (result.hasException) {
                                            return Text(
                                                result.exception.toString());
                                          }
                                          if (result.isLoading) {
                                            return CircularProgressIndicator();
                                          }
                                          var url = result.data!['profByUid'];
                                          return Image(
                                              height: d[0] * 0.5,
                                              width: d[1] * 0.7,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "http://192.168.43.165:8000/media/" +
                                                      Uri.parse(url)
                                                          .toString()));
                                        }),
                                    Container(
                                      height: 10,
                                    ),
                                    TextLabel(
                                      col: Colors.white,
                                      size: 20,
                                      style: FontStyle.italic,
                                      value: item["uname"],
                                    ),
                                    TextLabel(
                                      col: Colors.white,
                                      size: 15,
                                      style: FontStyle.italic,
                                      value: item["bio"],
                                    ),
                                  ],
                                ),
                                likeAction: () async {
                                  var r = await getmutation(
                                      {"se": u, "r": int.parse(item["id"])},
                                      reqmut,
                                      "sendRequest",
                                      "s");
                                  if (r == "done")
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Request Sent"),
                                      duration: Duration(milliseconds: 500),
                                    ));
                                },
                                nopeAction: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Better luck next time ;)"),
                                    duration: Duration(milliseconds: 500),
                                  ));
                                },
                                onSlideUpdate: (SlideRegion? region) async {
                                  print("Region $region");
                                }));

                            _matchEngine = MatchEngine(swipeItems: _swipeItems);
                          }
                        if(_swipeItems.length==0)
                          return Column(
                            children: [
                              Container(height: d[0]*0.2,),
                              TextLabel(col: Colors.white, style: FontStyle.normal, size: 20, value: "No Matches :(")
                            ],
                          );
                        else {

                          return SwipeCards(
                            matchEngine: _matchEngine!,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                alignment: Alignment.center,
                                child: _swipeItems[index].content,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                              );
                            },
                            onStackFinished: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Thats it for today :("),
                                    duration: Duration(milliseconds: 500),
                                  ));
                            },
                            itemChanged: (SwipeItem item, int index) {
                              print("item: ${item.content}, index: $index");
                            },
                            leftSwipeAllowed: true,
                            rightSwipeAllowed: true,
                            fillSpace: true,
                          );
                        }}));
            }
          }),
      Container(
        height: d[0] * 0.02,
      ),
    ]);
  }
}
