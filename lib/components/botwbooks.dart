import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/appscreens/bookclubscreen.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../funcnclass/dimensions.dart';

class BookButton extends StatelessWidget {
  final String querystr = """query(\$c:Int!){
              coverByCid(cid:\$c)
  }
  """;
  final String botwmut='''mutation(\$bc:Int!,\$b:Int!) {
              addBotw(bcid:\$bc,bid:\$b){
                      s
              } 
        }
''';
  final String bookname;
  final String au,name;
  final int cid,uid;
  final int bid;
  final int bcid;

  const BookButton(
      {required this.bookname,
        required this.cid,
        required this.au,
        required this.bid,
        required this.bcid,
      required this.uid,
      required this.name});

  @override
  Widget build(BuildContext context) {
    var di = dim(context);
    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        width: di[1] * 0.93,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextButton(
            onPressed: () async{
              var res=await getmutation({"bc":bcid,"b":bid}, botwmut, "addBotw", "s");
              if(res=="done") {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>BookClubScreen(bcid: bcid.toString(), name: name, uid: uid)));
              }
            },
            child: Row(children: [
              Query(
                  options: QueryOptions(
                      document: gql(querystr), variables: {"c": cid}),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return CircularProgressIndicator();
                    }
                    var d = result.data!['coverByCid'];
                    return Image(
                        image: NetworkImage(d.toString()),
                        width: di[1] * 0.1,
                        height: di[0] * 0.08);
                  }),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 5,
                ),
                Container(width: di[1]*0.7,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child:  TextLabel(
                  value: "$bookname",
                  style: FontStyle.normal,
                  col: Colors.white,
                  size: 22,
                ),)
               ,
                Container(
                  height: 5,
                ),
                TextLabel(
                  value: "    Author: $au",
                  style: FontStyle.normal,
                  col: Colors.white,
                  size: 12,
                ),
              ])
            ])));
  }
}
