import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/basicbg.dart';
import 'package:shelfobsessed/components/scrollbg.dart';
import 'package:shelfobsessed/components/smallerbutton.dart';
import 'package:shelfobsessed/components/datatextbox.dart';
import 'package:shelfobsessed/components/reviewtile.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import 'package:shelfobsessed/sharedpreferencehandler/getprefs.dart';
import '../funcnclass/jsondecode.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbutton.dart';

class BookScreen extends StatefulWidget {
  final int bid;

  const BookScreen({required this.bid});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  var u;
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 0),()async{
      var d=await getprefs();
      setState(() {
        u=d["uid"];
      });
    });
  }
  var review = TextEditingController();
  var read = "", wish = "";
  final String querystr = """query(\$c:Int!){
              coverByCid(cid:\$c)
  }
  """;

  var list=[1,2,3,4,5];
  var star=5;
  final String querystr1 = '''query(\$i:Int!){
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

  final String querystr2 = '''query(\$i:Int!){
              reviewsForBid(bid:\$i){
                       id
                       uid
                       rev
                       stars
                       replyto
              }
  }
  ''';

  final String mutstr1 = '''mutation(\$u:Int!,\$b:Int!,\$s:String!){
               editBook(uid:\$u,bid:\$b,set:\$s){
                        s
               }
  }''';

  var listquery = '''query(\$u:Int!,\$b:Int!){
              isAdded(uid:\$u,bid:\$b)
    }''';

  var starquery = '''query(\$b:Int!){
              overallRating(bid:\$b)
    }''';

  var revstr = '''mutation (\$b:Int!,\$u:Int!,\$r:String!,\$s:Int!){
              addReview(bid:\$b,uid:\$u,rev:\$r,st:\$s) {
                      d
              }
      }''';

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return ScrollBG(
        align: Alignment.center,
        imgname: "black.jpg",
        placed: 50,
        content: Query(
            options: QueryOptions(
                document: gql(querystr1), variables: {"i": widget.bid}),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return CircularProgressIndicator();
              }
              var j = jsondecsumm(result.data!['bookById'].toString());
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        width: d[1] * 0.35,
                        height: d[0] * 0.25,
                        child: Query(
                            options: QueryOptions(
                                document: gql(querystr),
                                variables: {"c": int.parse(j["cid"])}),
                            builder: (result, {fetchMore, refetch}) {
                              if (result.hasException) {
                                print(result.exception.toString());
                                return Text(result.exception.toString());
                              }
                              if (result.isLoading) {
                                return CircularProgressIndicator();
                              }
                              var i = result.data!['coverByCid'];
                              return Image(
                                image: NetworkImage(i.toString()),
                                height: d[0] * 0.2,
                                width: d[1] * 0.3,
                              );
                            })),
                    Container(
                      width: d[1] * 0.03,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: d[0] * 0.002,
                          ),
                          Container(width: d[1]*0.49,
                          child: TextLabel(
                              col: Colors.white,
                              style: FontStyle.normal,
                              size: 24,
                              value: j["bname"]),),
                          Row(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10,
                                ),
                                TextLabel(
                                    col: Colors.white,
                                    style: FontStyle.normal,
                                    size: 16,
                                    value: j["author"]),
                                Container(
                                  height: 5,
                                ),
                                TextLabel(
                                    col: Colors.white,
                                    style: FontStyle.normal,
                                    size: 16,
                                    value: "Year: " + j['year']),
                                Container(
                                  height: 5,
                                ),
                                TextLabel(
                                    col: Colors.white,
                                    style: FontStyle.normal,
                                    size: 16,
                                    value: "Genre: " + j['genre']),
                                Container(
                                  height: 5,
                                ),
                                Query(
                                    options: QueryOptions(
                                        document: gql(starquery),
                                        variables: {"b": widget.bid},
                                        fetchPolicy: FetchPolicy.noCache),
                                    builder: (result, {fetchMore, refetch}) {
                                      if (result.hasException) {
                                        return Text(
                                            result.exception.toString());
                                      }
                                      if (result.isLoading) {
                                        return CircularProgressIndicator();
                                      }
                                      var j = result.data!['overallRating'];
                                      return Row(children: [
                                        TextLabel(
                                            col: Colors.white,
                                            style: FontStyle.normal,
                                            size: 16,
                                            value: "Overall: " + j.toString()),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 15,
                                        )
                                      ]);
                                    }),
                                Container(
                                  height: 10,
                                ),
                                Query(
                                    options: QueryOptions(
                                        document: gql(listquery),
                                        variables: {"u": u, "b": widget.bid},
                                    fetchPolicy: FetchPolicy.noCache),
                                    builder: (result, {fetchMore, refetch}) {
                                      if (result.hasException) {
                                        print(result.exception!.linkException);
                                        return Text(
                                            result.exception.toString());
                                      }
                                      if (result.isLoading) {
                                        return CircularProgressIndicator();
                                      }
                                      var j =
                                          result.data!['isAdded'].toString();
                                      read = j.toString()[0] == "1"
                                          ? "Added"
                                          : "Read";
                                      wish = j.toString()[1] == "1"
                                          ? "Added"
                                          : "Wish";

                                      return Row(children: [
                                        Container(
                                          height: 20,
                                        ),
                                        Container(
                                            height: 50,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade200,
                                                    width: 2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: TextButton(
                                                onPressed: () async {
                                                  var res = await getmutation({
                                                    "u": u,
                                                    "b": widget.bid,
                                                    "s": "r"
                                                  }, mutstr1, "editBook", "s");
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>BookScreen(bid: widget.bid)));
                                                },
                                                child: Text(
                                                  "$read",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "font1",
                                                      fontSize: 20),
                                                ))),
                                        Container(
                                          width: 15,
                                        ),
                                        BasicButton(
                                          onpress: () async {
                                            print(widget.bid);
                                            print(u);
                                            var res = await getmutation({
                                              "u": u,
                                              "b": widget.bid,
                                              "s": "w"
                                            }, mutstr1, "editBook", "s");
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>BookScreen(bid: widget.bid)));
                                          },
                                          text: "$wish",
                                          w: 90,
                                          h: 50,
                                        ),
                                      ]);
                                    })
                              ],
                            ),
                            Container(
                              width: 18,
                            ),
                          ])
                        ])
                  ]),
                  Container(
                    height: 15,
                  ),
                  TextLabel(
                      col: Colors.white,
                      style: FontStyle.normal,
                      size: 17,
                      value: j["summary"]),
                  Container(
                    height: 20,
                  ),
                  TextLabel(
                      col: Colors.white,
                      style: FontStyle.italic,
                      size: 25,
                      value: "Reviews"),
                  Container(
                    height: 20,
                  ),
                  Container(
                    child: Query(
                        options: QueryOptions(
                            document: gql(querystr2),
                            variables: {"i": widget.bid}),
                        builder: (result, {fetchMore, refetch}) {
                          if (result.hasException) {
                            return Text(result.exception.toString());
                          }
                          if (result.isLoading) {
                            return CircularProgressIndicator();
                          }
                          List k =
                              jsondec(result.data!['reviewsForBid'].toString());
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (Map i in k.where((element) => int.parse(element["replyto"])==0))
                                ReviewTile(
                                  replying: 0,
                                  curr:u,
                                    bid: widget.bid,
                                    rid:int.parse(i["id"]),
                                    uid: int.parse(i["uid"]),
                                    review: i["rev"],
                                    stars: double.parse(i["stars"]),
                                replies:k.where((element) => element["replyto"].toString()==i["id"].toString().trim()).toList())
                            ],
                          );
                        }),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          BasicTF(
                              text: "add review",
                              h: d[1] * 0.1,
                              ctrl: review,
                              w: 0.5,
                              onchange: (value) {},
                              col: Colors.white),
                          Container(
                            width: 10,
                          ),
                          DropdownButton<String>(
                            dropdownColor: Colors.black,
                            value: star.toString(),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "font1",
                                fontSize: 20),
                            underline: Container(
                              height: 0.5,
                              color: Colors.white,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                star = int.parse(value!);
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Row(
                                  children: [
                                    TextLabel(value:value.toString(),col: Colors.white,size: 20,style: FontStyle.normal,),
                                    Icon(Icons.star,color: Colors.yellow,size: 15,)
                                  ],
                                ));
                            }).toList(),
                          ),
                          Container(width: 10,),
                          SmallerButton(
                              onpress: () async {
                                if (review.text.isNotEmpty)
                                  var res = await getmutation({
                                    "u": u,
                                    "b": widget.bid,
                                    "r": review.text,
                                    "s": star
                                  }, revstr, "addReview", "d");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>BookScreen(bid: widget.bid)));
                              },
                              text: "Post",
                              w: d[0] * 0.1,
                              h: d[1] * 0.1)
                        ],
                      ))
                ],
              );
            }));
  }
}
