import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelfobsessed/appscreens/addpostscreen.dart';
import 'package:shelfobsessed/appscreens/friendlist.dart';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/appscreens/profilebooklists.dart';
import 'package:shelfobsessed/appscreens/welcome.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/feedtile.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../components/pfpwidget.dart';
import '../components/smallerbutton.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'chapters.dart';
import 'questions.dart';

import 'editprofile.dart';

class ProfileScreen extends StatefulWidget {
  final int uid;

  ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var postquery = '''query(\$u:Int!) {
                      postsForUid(uid:\$u){
                            content
                      }
                  }''';
  var authmut="""mutation(\$u:Int!){
                    regAuthor(uid:\$u){
                          s
                    }
                 }""";
  var userquery = '''query(\$u:Int!) {
                    userById(uid:\$u) {
                        uname
                        gen
                        dob
                        bio
                        pid
                        friend
                        read
                        wl
                        isauth
                    }
              }''';

  @override
  Widget build(BuildContext context) {
    print("here");
    List<double> d = dim(context);
    return BasicBG(
        align: Alignment.topLeft,
        imgname: "bg3.jpg",
        placed: 40,
        content: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: Query(
                  options: QueryOptions(
                    document: gql(userquery),
                    variables: {"u": widget.uid},
                  ),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      print(result.exception.toString());
                      return Text(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return CircularProgressIndicator();
                    }
                    var i = result.data!['userById'];
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PFPWidget(uid: widget.uid, side: d[0] * 0.15),
                              Container(
                                width: d[0] * 0.03,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextLabel(
                                      value: i["uname"],
                                      col: Colors.grey.shade200,
                                      style: FontStyle.normal,
                                      size: 30,
                                    ),
                                    Container(
                                      height: d[0] * 0.02,
                                    ),
                                    SmallerButton(
                                        onpress: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          EditProfile(
                                                            uname: i["uname"],
                                                              dob: i["dob"],
                                                              gen: i["gen"],
                                                              bio: i["bio"],
                                                              pid: i["pid"],
                                                              uid: widget.uid)));
                                        },
                                        text: "Edit Profile",
                                        w: d[1] * 0.5,
                                        h: d[0] * 0.044),
                                    Container(
                                      height: d[0] * 0.02,
                                    ),
                                    SmallerButton(
                                        onpress: () async {
                                          var pref = await SharedPreferences
                                              .getInstance();
                                          pref.clear();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          WelcomePage()));
                                        },
                                        text: "Logout",
                                        w: d[1] * 0.5,
                                        h: d[0] * 0.044)
                                  ]),
                            ],
                          ),
                          Container(
                            height: 20,
                          ),
                          TextLabel(
                              col: Colors.grey.shade200,
                              style: FontStyle.normal,
                              size: 15,
                              value: i["bio"]),
                          Container(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(width: d[1]*0.01,),
                              SmallerButton(onpress: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ProfileLists(uid: widget.uid,data: i["read"]??[],type:"Reading List")));
                              }, text: "Read", w: d[1]*0.25, h: d[0]*0.06),
                              Container(width: d[1]*0.06,),
                              SmallerButton(onpress: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ProfileLists(uid: widget.uid,data: i["wl"]??[],type:"Wish List")));
                              }, text: "Wished", w: d[1]*0.25, h: d[0]*0.06),
                              Container(width: d[1]*0.06,),
                              SmallerButton(onpress: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>FriendList(uid: widget.uid)));
                              }, text: "Friends", w: d[1]*0.25, h: d[0]*0.06),
                            ],
                          ),
                          Container(height: 15,),
                          i["isauth"]==1?SmallerButton(onpress: (){Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>Chapters(uid:widget.uid)));}, text: "Chapters", w: d[1]*0.3, h: d[1]*0.1):Container(height: 0,),
                          Container(height:15),
                          TextLabel(
                              col: Colors.grey.shade200,
                              style: FontStyle.normal,
                              size: 30,
                              value: "FEED\n"),
                          Query(
                              options: QueryOptions(
                                document: gql(postquery),
                                variables: {"u": widget.uid},
                              ),
                              builder: (result, {fetchMore, refetch}) {
                                if (result.hasException) {
                                  print(result.exception.toString());
                                  return Text(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  return CircularProgressIndicator();
                                }
                                var i = result.data!['postsForUid'];
                                return Column(
                                  children: [
                                    for (var j in i)
                                      FeedTile(
                                          uid: widget.uid,
                                          content: j["content"],
                                        w: d[0],
                                      ),
                                  ],
                                );
                              }),
                          Row(
                            children:[
                              BasicButton(
                              onpress: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddPost(uid:widget.uid)));
                              },
                              text: "New Post",
                              w: d[1] * 0.3,
                              h: d[1] * 0.15,
                            ),
                              Container(width: 20,),
                              BasicButton(
                                onpress:  () async{
                                  var res =await  getmutation(
                                      {"u": widget.uid}, authmut, "regAuthor",
                                      "s");
                                  print(res);
                                  if (res == "done") {
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TabsScreen(uid: widget.uid)));
                                  }
                                },
                                text:i["isauth"]==1?"Unregister?":"Be an Author",
                                w: d[1] * 0.5,
                                h: d[1] * 0.15,
                              )
                            ]
                          )
                        ]);
                  },
                ))));
  }
}
