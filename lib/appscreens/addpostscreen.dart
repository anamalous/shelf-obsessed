import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/home.dart';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/appscreens/profilescreen.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/multilinetb.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';

class AddPost extends StatelessWidget {
  final int uid;
  AddPost({super.key,required this.uid});

  var post = TextEditingController();
  var postmut='''mutation(\$u:Int!,\$c:String!) {
                      newPost(uid:\$u,cont:\$c) {
                          s
                      }
                  }''';
  @override
  Widget build(BuildContext context) {
    List<double> d=dim(context);
    return BasicBG(
        align: Alignment.center,
        imgname:"bg3.jpg",
        placed:100,
        content:Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                TextLabel(col: Colors.grey.shade200, style: FontStyle.normal, size: 30, value: "Create Post "),
                Container(height: 40,),
                BasicTF(h:d[0]*0.4,text: "Enter username",ctrl:post,w:0.9,onchange:(value){},col: Colors.black,),
                Container(height: 20,),
                BasicButton(onpress: ()async{
                  var res=await getmutation({"u":uid,"c":post.text}, postmut, "newPost", "s");
                  if(res=="done")
                    Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>TabsScreen(uid: uid)));
                }, text: "Upload", w: 200,h: 50,)
              ],
            )
        )

    );
  }
}
