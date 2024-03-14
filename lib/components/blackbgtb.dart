import 'package:flutter/material.dart';

import '../funcnclass/dimensions.dart';

class BasicTF extends StatelessWidget {
  final String text;
  final Function(String) onchange;
  final TextEditingController ctrl;
  final double h;
  final double w;
  final Color col;
  const BasicTF({required this.text,required this.h,required this.ctrl,required this.w,required this.onchange,required this.col});

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: h,
        width: d[1] * w,
        decoration: BoxDecoration(
            color: col,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextField(
          onChanged:onchange,
          controller: ctrl,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "font1",
            fontSize: 18,
          ),
          decoration: InputDecoration(
              hintText: text
          ),
        ));
  }
}
