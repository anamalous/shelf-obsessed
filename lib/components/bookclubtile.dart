import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/bookclubscreen.dart';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';

import '../funcnclass/dimensions.dart';

class BookClubTile extends StatelessWidget {
  final bcid, name, uid;

  final String delclub = '''mutation(\$u:Int!,\$b:Int!) {
                              exitMember(uid:\$u,bcid:\$b){
                                      s
                               }
                        }''';

  const BookClubTile(
      {required this.bcid, required this.name, required this.uid});

  @override
  Widget build(BuildContext context) {
    var d = dim(context);
    return TextButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>BookClubScreen(bcid: bcid,name:name,uid: uid,)));
    }, child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        alignment: Alignment.topLeft,
        width: d[1],
        height: d[0]*0.1,
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextLabel(
              col: Colors.white,
              style: FontStyle.normal,
              size: 20,
              value: name,),
            Container(width: 20,),
            BasicButton(onpress: () async {
              var res = await getmutation(
                  {"u": uid, "b": int.parse(bcid)}, delclub, "exitMember", "s");
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Removed"),
                duration: Duration(milliseconds: 500),
              ));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>TabsScreen(uid: uid)));
            }, text: "Leave", w: d[1] * 0.3, h: d[0] * 0.05)
          ],
        )
    ));
  }
}
