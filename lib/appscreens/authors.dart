import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/scrollbg.dart';

import '../components/authortile.dart';
import '../components/textlabel.dart';
import '../funcnclass/jsondecode.dart';

class Authors extends StatefulWidget{
  @override
  State<Authors> createState() => _AuthorsState();
}

class _AuthorsState extends State<Authors> {
  String authsquery="""query{
                            getAuths {
                                uid
                            }
                      }""";
  Widget build(BuildContext context){
    return ScrollBG(imgname: "bg3.jpg",
        content: Container(
          child: Column(children: [
            Query(
                options: QueryOptions(
                    document: gql(authsquery),),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return CircularProgressIndicator();
                  }
                  var k =
                  jsondec(result.data!['getAuths'].toString());
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for(var i in k)
                          AuthorTile(uid: int.parse(i["uid"]),)
                      ],
                    );
                }),],),
        ),
        placed: 0,align: Alignment.center);
  }
}