import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/home.dart';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/appscreens/profilescreen.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/basicdialog.dart';
import 'package:shelfobsessed/components/multilinetb.dart';
import 'package:shelfobsessed/components/scrollbg.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';

class AddChapter extends StatelessWidget {
  final int uid;
  AddChapter({super.key,required this.uid});
  var chap=TextEditingController();
  var cont = TextEditingController();
  var postmut='''mutation(\$ch:String!,\$co:String!,\$u:Int!) {
                      addChapter(uid:\$u,content:\$co,chap:\$ch) {
                          s
                      }
                  }''';
  @override
  Widget build(BuildContext context) {
    List<double> d=dim(context);
    return ScrollBG(
        align: Alignment.center,
        imgname:"bg3.jpg",
        placed:50,
        content:Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                TextLabel(col: Colors.grey.shade200, style: FontStyle.normal, size: 30, value: "Create Chapter "),
                Container(height: 40,),
                TextLabel(col: Colors.white, style: FontStyle.italic, size: 20, value: "Title:"),
                Container(height: 10,),
                BasicTF(text: "Title...", h: d[0]*0.08, ctrl: chap, w:0.9, onchange: (value){}, col: Colors.black),
                Container(height: 10,),
                TextLabel(col: Colors.white, style: FontStyle.italic, size: 20, value: "Chapter:"),
                Container(height: 10,),
                BasicTF(h:d[0]*0.4,text: "Enter username",ctrl:cont,w:0.9,onchange:(value){},col: Colors.black,),
                Container(height: 20,),
                BasicButton(onpress: ()async{
                  if(cont.text==""||chap.text=="")
                    dialogprompt(context, "enter title and content");
                  else{
                  var res=await getmutation({"u":uid,"co":cont.text,"ch":chap.text}, postmut, "addChapter", "s");
                  if(res=="done")
                    Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>TabsScreen(uid: uid)));
                }}, text: "Upload", w: 200,h: 50,)
              ],
            )
        )

    );
  }
}
