import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/basicbg.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/components/usertile.dart';
import '../funcnclass/jsondecode.dart';
import '../funcnclass/dimensions.dart';

class Requests extends StatefulWidget {
  final int uid;

  const Requests({required this.uid});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  String getreq = '''query(\$u:Int!) {
                      userById(uid:\$u){
                          req
                      }
                  }''';

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return BasicBG(
        align: Alignment.center,
        imgname: "bg3.jpg",
        placed: 60,
        content: Column(
          children: [
            TextLabel(
                col: Colors.white,
                style: FontStyle.normal,
                size: 30,
                value: "Requests"),
            Container(
              height: 20,
            ),
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
                      jsondecparam(result.data!['userById'].toString(), "req");
                  if (k["req"].toString() == "[ul]"||k["req"].toString()=="[]")
                    return TextLabel(
                        col: Colors.white,
                        style: FontStyle.normal,
                        size: 30,
                        value: "No Requests Right Now");
                  else
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (var i in k["req"])
                          UserTile(
                            send: int.parse(i),
                            curr: widget.uid,
                          )
                      ],
                    );
                }),
          ],
        ));
  }
}
