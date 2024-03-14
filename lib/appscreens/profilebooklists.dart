import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/basicbg.dart';
import 'package:shelfobsessed/components/bookbutton.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/components/usertile.dart';
import '../funcnclass/dimensions.dart';
import '../funcnclass/jsondecode.dart';

class ProfileLists extends StatefulWidget {
  final int uid;
  final List data;
  final String type;

  const ProfileLists({required this.uid,required this.data,required this.type});

  @override
  State<ProfileLists> createState() => _ProfileListsState();
}

class _ProfileListsState extends State<ProfileLists> {

  String getreq='''query(\$u:Int!) {
                      userById(uid:\$u){
                          req
                      }
                  }''';
  String accquery='''mutation {
                        acceptRequest(send:1,acc:18){
                            s
                        }
                      }
                  ''';
  final String bookquery = '''query(\$i:Int!){
              bookById(bid:\$i){
                        bname
                        author
                        genre
                        year
                        cid
                        summary
              }
  }
  ''';
  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return BasicBG(
        align: Alignment.center,
        imgname: "bg3.jpg",
        placed: 60,
        content: Column(children: [
          TextLabel(col: Colors.white, style: FontStyle.normal, size: 30, value: widget.type),
          Container(height: 20,),
          Column(
            children: [
              if(widget.data==null||widget.data.length==0)
                TextLabel(col: Colors.white, style: FontStyle.normal, size: 30, value: "No Books Added")
              else
              for(var i in widget.data)
                Query(
                    options: QueryOptions(
                        document: gql(bookquery),
                        variables: {"i": i}),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return CircularProgressIndicator();
                      }
                      var k =
                      jsondecsumm(result.data!['bookById'].toString());
                        return BookButton(bookname: k["bname"], cid: int.parse(k["cid"]), au: k["author"], bid: i, uid: widget.uid);
                    })
            ],
          )],)
    );
  }

}

