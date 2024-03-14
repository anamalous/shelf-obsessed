import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/components/basicbg.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../funcnclass/dimensions.dart';

class Questions extends StatefulWidget {
  final int uid;

  const Questions({required this.uid});

  @override
  State<Questions> createState() => _QuestionsState();
}


List q1 = ["Romance", "Sci-fi", "Horror/Thriller", "Non-fiction"];
List q2 = [
  "I love books",
  "Um.. my kindle is the best",
  "Audio books <3",
  "Do comics count?"
];
List q3 = [
  "Pride and Prejudice",
  "Little Women",
  "Jane Eyre",
  "Wuthering heights"
];
List q4 = ["The Faraway Tree", "Matilda", "Horrid Henry", "Charlotte's Web"];
List q5 = [
  "To Kill A Mockinbird",
  "Lord Of The Rings",
  "Fight Club",
  "Shawshank Redemption"
];

class _QuestionsState extends State<Questions> {
  List ans = [0, 0, 0, 0, 0];
  var ansmut='''mutation(\$u:Int!,\$ans:[Int!]) {
                    profQuestions(uid:\$u,a:\$ans) {
                          set
                    }
                }''';
  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return BasicBG(
        align: Alignment.topLeft,
        imgname: "black.jpg",
        placed: 80,
        content: Container(
            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLabel(
                      col: Colors.white,
                      style: FontStyle.normal,
                      size: 30,
                      value: "\t\t\tThere's something\n\t\t about you <3"),
                  Container(
                    height: 20,
                  ),
                  Image(image: AssetImage("assets/images/cute.png")),
                  Container(
                    height: 20,
                  ),
                  TextLabel(
                      col: Colors.white,
                      style: FontStyle.normal,
                      size: 20,
                      value: "\t\t\t\t\t1. Favourite genre?"),
                  for (var i in q1)
                    ListTile(
                      title: TextLabel(
                        col: Colors.white,
                        size: 18,
                        style: FontStyle.italic,
                        value: i,
                      ),
                      leading: Radio(
                        value: q1.indexOf(i),
                        groupValue: ans[0],
                        onChanged: (value) {
                          setState(() {
                            ans[0] = q1.indexOf(i);
                          });
                        },
                      ),
                    ),
                  Container(
                    height: 20,
                  ),
                  TextLabel(
                      col: Colors.white,
                      style: FontStyle.normal,
                      size: 20,
                      value: "\t\t\t\t\t2. Are you a reader or...??"),
                  for (var i in q2)
                    ListTile(
                      title: TextLabel(
                        col: Colors.white,
                        size: 18,
                        style: FontStyle.italic,
                        value: i,
                      ),
                      leading: Radio(
                        value: q2.indexOf(i),
                        groupValue: ans[1],
                        onChanged: (value) {
                          setState(() {
                            ans[1] = q2.indexOf(i);
                          });
                        },
                      ),
                    ),
                  Container(
                    height: 20,
                  ),
                  TextLabel(
                      col: Colors.white,
                      style: FontStyle.normal,
                      size: 20,
                      value: "\t\t\t\t\t3. Favourite girly classic?"),
                  for (var i in q3)
                    ListTile(
                      title: TextLabel(
                        col: Colors.white,
                        size: 18,
                        style: FontStyle.italic,
                        value: i,
                      ),
                      leading: Radio(
                        value: q3.indexOf(i),
                        groupValue: ans[2],
                        onChanged: (value) {
                          setState(() {
                            ans[2] = q3.indexOf(i);
                          });
                        },
                      ),
                    ),
                  Container(
                    height: 20,
                  ),
                  TextLabel(
                      col: Colors.white,
                      style: FontStyle.normal,
                      size: 20,
                      value: "\t\t\t\t\t4. Childhood fav??"),
                  for (var i in q4)
                    ListTile(
                      title: TextLabel(
                        col: Colors.white,
                        size: 18,
                        style: FontStyle.italic,
                        value: i,
                      ),
                      leading: Radio(
                        value: q4.indexOf(i),
                        groupValue: ans[3],
                        onChanged: (value) {
                          setState(() {
                            ans[3] = q4.indexOf(i);
                          });
                        },
                      ),
                    ),
                  Container(
                    height: 20,
                  ),
                  TextLabel(
                      col: Colors.white,
                      style: FontStyle.normal,
                      size: 20,
                      value: "\t\t\t\t\t5. Cult-classic adaptations"),
                  for (var i in q5)
                    ListTile(
                      title: TextLabel(
                        col: Colors.white,
                        size: 18,
                        style: FontStyle.italic,
                        value: i,
                      ),
                      leading: Radio(
                        value: q5.indexOf(i),
                        groupValue: ans[4],
                        onChanged: (value) {
                          setState(() {
                            ans[4] = q5.indexOf(i);
                          });
                        },
                      ),
                    ),
                  Container(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                    alignment: Alignment.topRight,
                    child: BasicButton(
                        onpress: () async{
                          for (var i = 0; i < ans.length; i++) ans[i] += 1;
                          var res=await getmutation({"u":widget.uid,"ans":ans}, ansmut, "profQuestions", "set");
                          if(res==true){
                            Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>TabsScreen(uid: widget.uid)));
                        }},
                        text: "DoNe",
                        w: d[1] * 0.3,
                        h: d[0] * 0.06),
                  ),
                  Container(
                    height: d[0] * 0.2,
                  )
                ],
              ),
            )));
  }
}
