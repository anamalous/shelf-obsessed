import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/appscreens/addbotw.dart';
import 'package:shelfobsessed/appscreens/addclubpost.dart';
import 'package:shelfobsessed/components/basicbg.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/clubfeedtile.dart';
import 'package:shelfobsessed/components/smallerbutton.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import '../funcnclass/jsondecode.dart';
import '../funcnclass/dimensions.dart';

class BookClubScreen extends StatelessWidget {
  final bcid, name, uid;
  final String getreq = '''query(\$bc:Int!){
                               clubByBcid(bcid:\$bc) {
                                      admin
                                      members
                               }
                            }''';
  final String botwque = '''query(\$bc:Int!){
                               botwForBcid(bcid:\$bc) {
                                        id
                                        bname
                               }
                            }''';
  final String users = '''query(\$u:Int!){
                            userById(uid:\$u){
                                  uname
                            }
                        }''';
  final feed = '''query(\$b:Int!) {
  getClubFeed(bcid:\$b) {
    uid
    botw
    content
  }
}''';

  const BookClubScreen(
      {required this.bcid, required this.name, required this.uid});

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return BasicBG(
        align: Alignment.topLeft,
        imgname: "bg3.jpg",
        placed: 40,
        content: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Query(
                  options: QueryOptions(
                      document: gql(getreq),
                      variables: {"bc": int.parse(bcid)}),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Text(result.exception!.linkException!.toString());
                    }
                    if (result.isLoading) {
                      return CircularProgressIndicator();
                    }
                    var k = jsondecparam(
                        result.data!['clubByBcid'].toString(), "members");
                    print(k['admin']);
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextLabel(
                              col: Colors.white,
                              style: FontStyle.italic,
                              size: 20,
                              value: name.toString().toUpperCase()),
                          int.parse(k["admin"]) != uid
                              ? Container(
                                  height: 0,
                                )
                              : SmallerButton(
                                  onpress: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddBotw(
                                                    bcid: bcid,
                                                    name: name,
                                                    uid: uid)));
                                  },
                                  text: "+",
                                  w: d[1] * 0.1,
                                  h: d[0] * 0.05),

                          PopupMenuButton(
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            color: Colors.white,
                            itemBuilder: (BuildContext context) => [
                              for (var i in k["members"])
                                PopupMenuItem(
                                  value: i,
                                  child: Query(
                                      options: QueryOptions(
                                          document: gql(users),
                                          variables: {"u": int.parse(i)}),
                                      builder: (result, {fetchMore, refetch}) {
                                        if (result.hasException) {
                                          return Text(result
                                              .exception!.linkException!
                                              .toString());
                                        }
                                        if (result.isLoading) {
                                          return CircularProgressIndicator();
                                        }
                                        var j = jsondec(result.data!['userById']
                                            .toString());
                                        print(result);
                                        return Text(j["uname"]);
                                      }),
                                )
                            ],
                          )
                        ]);
                  }),
              Container(
                height: d[0] * 0.04,
              ),
              Query(
                  options: QueryOptions(
                      document: gql(feed), variables: {"b": int.parse(bcid)}),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Text(result.exception!.linkException!.toString());
                    }
                    if (result.isLoading) {
                      return CircularProgressIndicator();
                    }
                    var k = jsondec(result.data!['getClubFeed'].toString());
                    return Column(
                      children: [
                        for (var item in k)
                          ClubFeedTile(
                              uid: int.parse(item["uid"]),
                              content: item["content"],
                              w: d[1],
                              bid: int.parse(item["botw"]))
                      ],
                    );
                  }),
              Query(
                  options: QueryOptions(
                      document: gql(botwque),
                      variables: {"bc": int.parse(bcid)}),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Text(result.exception!.linkException!.toString());
                    }
                    if (result.isLoading) {
                      return CircularProgressIndicator();
                    }
                    var k = jsondec(result.data!['botwForBcid'].toString());
                    return BasicButton(
                        onpress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AddClubPost(
                                          uid: uid,
                                          botws: k,
                                          bcid: int.parse(bcid),
                                          name: name)));
                        },
                        text: "Add Post",
                        w: d[1] * 0.4,
                        h: d[0] * 0.05);
                  }),
            ],
          ),
        ));
  }
}
