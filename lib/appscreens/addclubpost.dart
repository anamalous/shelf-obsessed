import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/appscreens/bookclubscreen.dart';
import 'package:shelfobsessed/appscreens/home.dart';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/appscreens/profilescreen.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/basicdialog.dart';
import 'package:shelfobsessed/components/blackbgtb.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';
import '../funcnclass/jsondecode.dart';

class AddClubPost extends StatefulWidget {
  final int uid,bcid;
  final name;
  final List botws;

  AddClubPost({super.key, required this.uid, required this.botws,required this.bcid,required this.name});

  @override
  State<AddClubPost> createState() => _AddClubPostState();
}

class _AddClubPostState extends State<AddClubPost> {
  var post = TextEditingController();
  String botw = "";

  final String bookquery = '''query(\$i:Int!){
              bookById(bid:\$i){
                        bname
              }
  }
  ''';
  var postmut = '''mutation(\$u:Int!,\$c:String!,\$b:Int!,\$bo:Int!) {
                      newClubPost(uid:\$u,cont:\$c,bcid:\$b,botw:\$bo) {
                          s
                      }
                  }''';

  @override
  Widget build(BuildContext context) {
    if(botw==""&& widget.botws.isNotEmpty)
      botw=widget.botws.first["id"].toString();
    print(widget.botws);
    List<double> d = dim(context);
    return BasicBG(
        align: Alignment.center,
        imgname: "bg3.jpg",
        placed: 100,
        content: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextLabel(
                    col: Colors.grey.shade200,
                    style: FontStyle.normal,
                    size: 30,
                    value: "Create Post "),
                Container(
                  height: 40,
                ),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: botw.toString(),
                  elevation: 16,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: "font1", fontSize: 20),
                  underline: Container(
                    height: 0.5,
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      botw = value!;
                    });
                  },
                  items: widget.botws.map<DropdownMenuItem<String>>((value) {
                    print(value["id"]);
                    return DropdownMenuItem<String>(
                        value: value["id"],
                        child: TextLabel(
                                    value: value["bname"].toString(),
                                    col: Colors.white,
                                    size: 20,
                                    style: FontStyle.normal,
                                  ),
                                );
                  }).toList(),
                ),
                Container(
                  height: d[0] * 0.02,
                ),
                BasicTF(
                  h: d[0] * 0.4,
                  text: "Enter username",
                  ctrl: post,
                  w: 0.9,
                  onchange: (value) {},
                  col: Colors.black,
                ),
                Container(
                  height: 20,
                ),
                BasicButton(
                  onpress: () async {
                    var res = await getmutation({"u": widget.uid, "c": post.text,"b":widget.bcid,"bo":int.parse(botw)},
                        postmut, "newClubPost", "s");
                    if (res == "done"){
                      Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BookClubScreen(bcid: widget.bcid.toString(),uid:widget.uid,name: widget.name,)));
                  }
                    else{
                      dialogprompt(context, res);
                    }
                    },
                  text: "Upload",
                  w: 200,
                  h: 50,
                )
              ],
            )));
  }
}
