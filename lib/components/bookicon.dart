import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../appscreens/bookscreen.dart';
import '../funcnclass/dimensions.dart';

class BookIcon extends StatelessWidget {
  final String querystr = """query(\$c:Int!){
              coverByCid(cid:\$c)
  }
  """;
  final String recmut='''mutation(\$u:Int!,\$b:Int!) {
              newRecent(uid:\$u,bid:\$b){
                      i
              } 
        }
''';
  final String bookname;
  final String au;
  final int cid;
  final int bid;
  final int uid;

  const BookIcon(
      {required this.bookname,
      required this.cid,
      required this.au,
      required this.bid,
      required this.uid});
  @override
  Widget build(BuildContext context) {
    var di = dim(context);
    return TextButton(
            onPressed: () async{
              var res=await getmutation({"u":uid,"b":bid}, recmut, "newRecent", "i");
              print(res);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => BookScreen(bid: bid)));
            },
            child: Column(children: [
              Query(
                  options: QueryOptions(
                    document: gql(querystr),
                    variables: {"c":cid}
                  ),
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
                        width: di[1]*0.35,
                        height: di[0]*0.25
                    );
                  }),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  height: 5,
                ),
                Container(
                  width: di[1]*0.35,
                  alignment: Alignment.center,
                  child: TextLabel(
                  value: bookname,
                  style: FontStyle.normal,
                  col: Colors.white,
                  size: 12,
                ),),
              ])
            ]));
  }
}
