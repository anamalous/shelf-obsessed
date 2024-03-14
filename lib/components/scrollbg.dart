import 'package:flutter/material.dart';

import '../funcnclass/dimensions.dart';

class ScrollBG extends StatelessWidget{
  final String imgname;
  final Widget content;
  final double placed;
  final Alignment align;
  const ScrollBG({required this.imgname,required this.content, required this.placed, required this.align});
  @override
  Widget build(BuildContext context){
    List<double> d=dim(context);
    return Scaffold(
        body:SingleChildScrollView(
            child:Container(
                height: d[0],
                width: d[1],
                padding: EdgeInsets.fromLTRB(0, placed, 0, 0),
                decoration: BoxDecoration(
                    image:DecorationImage(
                      image: AssetImage("assets/images/$imgname"),
                      fit: BoxFit.cover,
                    )
                ),
                alignment: align,
                child:content
            )
        )
    );
  }
}