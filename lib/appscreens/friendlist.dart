import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/basicbg.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import '../components/friendtile.dart';
import '../funcnclass/jsondecode.dart';
import '../funcnclass/dimensions.dart';

class FriendList extends StatefulWidget {
  final int uid;

  const FriendList({required this.uid});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  String getreq='''query(\$u:Int!) {
                      userById(uid:\$u){
                          friend
                      }
                  }''';
  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return BasicBG(
        align: Alignment.center,
        imgname: "bg3.jpg",
        placed: 60,
        content: Column(children: [
          TextLabel(col: Colors.white, style: FontStyle.normal, size: 30, value: "FriendList"),
          Container(height: 20,),
          Query(
              options: QueryOptions(
                  document: gql(getreq),
                  variables: {"u": widget.uid}),
              builder: (result, {fetchMore, refetch}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return CircularProgressIndicator();
                }
                var k =
                jsondecparam(result.data!['userById'].toString(),"friend");
                if(k["friend"].toString()=="[ul]"||k["friend"].toString()=="[]")
                  return TextLabel(col: Colors.white, style: FontStyle.normal, size: 30, value: "No Friends Yet");
                else
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for(var i in k["friend"])
                        FriendTile(send: int.parse(i),curr: widget.uid,)
                    ],
                  );
              }),],)
    );
  }

}

