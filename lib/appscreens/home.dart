import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/bookicon.dart';
import 'package:shelfobsessed/components/feedtile.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import '../components/basicbg.dart';
import '../funcnclass/jsondecode.dart';
import '../funcnclass/dimensions.dart';

class HomeScreen extends StatefulWidget {
  final int uid;

  HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => HomeState();
}

class HomeState extends State<HomeScreen> {
  final String getrec = '''query(\$u:Int!){
              recents(uid:\$u){
                      id
                      bname
                      cid
                      author
              }
      }            
''';

  final String authstr = '''query(\$u:Int!) {
              recentAuthor(uid:\$u){
                      id
                      bname
                      cid
                      author
              } 
      }''';
  final String feedquery = '''query(\$u:Int!) {
                                feedForUid(uid:\$u) {
                                        id
                                        uid
                                }
                            }''';
  var postquery = '''query(\$u:Int!) {
                      postForId(fid:\$u){
                            content
                      }
                  }''';

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return BasicBG(
        imgname: "bg3.jpg",
        placed: 40,
        align: Alignment.topLeft,
        content: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: ListView(children: [
            TextLabel(
                col: Colors.white,
                style: FontStyle.normal,
                size: 25,
                value: "Your recents"),
            SingleChildScrollView(
                padding: EdgeInsets.all(5),
                scrollDirection: Axis.horizontal,
                child: Query(
                    options: QueryOptions(
                        pollInterval: Duration(seconds: 5),
                        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
                        document: gql(getrec),
                        variables: {"u": widget.uid},
                        fetchPolicy: FetchPolicy.networkOnly),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return CircularProgressIndicator();
                      }
                      var d = jsondec(result.data!['recents'].toString());
                      return Row(children: [
                        for (var i in d)
                          BookIcon(
                            bookname: i["bname"],
                            cid: int.parse(i["cid"]),
                            au: i["author"],
                            bid: int.parse(i["id"]),
                            uid: widget.uid,
                          ),
                      ]);
                    })),
            TextLabel(
                col: Colors.white,
                style: FontStyle.normal,
                size: 25,
                value: "People on your radar\n"),
            SingleChildScrollView(
                padding: EdgeInsets.all(5),
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: d[0] * 0.2,
                  child: Query(
                      options: QueryOptions(
                        pollInterval: Duration(seconds: 5),
                        document: gql(feedquery),
                        variables: {"u": widget.uid},
                      ),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return Text(result.exception.toString());
                        }
                        if (result.isLoading) {
                          return CircularProgressIndicator();
                        }
                        var data =
                            jsondec(result.data!['feedForUid'].toString());
                        if (data.toString() == "[]"||data.toString()=="null")
                          return TextLabel(
                              col: Colors.white,
                              style: FontStyle.normal,
                              size: 20,
                              value: "No Posts Right Now :(");
                        else {
                          return Row(children: [
                            for (var i in data)
                              Query(
                                  options: QueryOptions(
                                    document: gql(postquery),
                                    variables: {"u": int.parse(i["id"])},
                                  ),
                                  builder: (result, {fetchMore, refetch}) {
                                    if (result.hasException) {
                                      print(result.exception.toString());
                                      return Text(result.exception.toString());
                                    }
                                    if (result.isLoading) {
                                      return CircularProgressIndicator();
                                    }
                                    var c = result.data!['postForId'];
                                    return FeedTile(
                                      uid: int.parse(i["uid"]),
                                      content: c["content"],
                                      w: d[1] * 0.7,
                                    );
                                  })
                          ]);
                        }
                      }),
                )),
            TextLabel(
                col: Colors.white,
                style: FontStyle.normal,
                size: 25,
                value: "More By your Favoruite"),
            SingleChildScrollView(
                padding: EdgeInsets.all(5),
                scrollDirection: Axis.horizontal,
                child: Query(
                    options: QueryOptions(
                      pollInterval: Duration(seconds: 5),
                      document: gql(authstr),
                      variables: {"u": widget.uid},
                    ),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return CircularProgressIndicator();
                      }
                      var d = jsondec(result.data!['recentAuthor'].toString());
                      return Row(children: [
                        for (var i in d)
                          BookIcon(
                              bookname: i["bname"],
                              cid: int.parse(i["cid"]),
                              au: i["author"],
                              bid: int.parse(i["id"]),
                              uid: widget.uid),
                      ]);
                    })),
            Container(
              height: d[1] * 0.2,
            )
          ]),
        ));
  }
}
