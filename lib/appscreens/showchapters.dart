import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/basicbg.dart';
import 'package:shelfobsessed/components/textlabel.dart';

import '../funcnclass/jsondecode.dart';

class ShowChapter extends StatefulWidget {
  String cname;

  ShowChapter({super.key, required this.cname});

  @override
  State<ShowChapter> createState() => _ShowChapterState();
}

class _ShowChapterState extends State<ShowChapter> {
  String chapquery = """query(\$u:String!){
                         getChapContent(cname:\$u)
                      }""";

  Widget build(BuildContext context) {
    return BasicBG(
        imgname: "bg3.jpg",
        content: SingleChildScrollView(
          child: Container(padding:EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
            children: [
              TextLabel(
                  col: Colors.white,
                  style: FontStyle.normal,
                  size: 30,
                  value: "  " + widget.cname),
              Query(
                  options: QueryOptions(
                      document: gql(chapquery), variables: {"u": widget.cname}),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return CircularProgressIndicator();
                    }
                    var k = result.data!['getChapContent'];
                    return Text(k, maxLines: 200,style: TextStyle(color: Colors.white,fontFamily: "font1"),);
                  })
            ],
          ),),
        ),
        placed: 50,
        align: Alignment.topLeft);
  }
}
