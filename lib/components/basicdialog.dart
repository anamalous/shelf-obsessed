import 'package:flutter/material.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/textlabel.dart';

dialogprompt(BuildContext context,String message){
  showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            contentPadding:EdgeInsets.all(1),
            content: Container(
              padding: EdgeInsets.all(10),
              color: Colors.black,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextLabel(col: Colors.white, style: FontStyle.normal, size: 20, value: message),
                  Container(height: 10,),
                  BasicButton(onpress: () => Navigator.pop(context), text: "Okay",w: 100,h: 50,)
                ],
              ),
            ),
          ));
}