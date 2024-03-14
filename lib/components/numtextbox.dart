import 'package:flutter/material.dart';

import '../funcnclass/dimensions.dart';

class NumTF extends StatelessWidget {
  final String text;
  final Function(String) onchange;
  final TextEditingController ctrl;
  final double h;
  final double w;
  final Color col;
  const NumTF({required this.text,required this.h,required this.ctrl,required this.w,required this.onchange,required this.col});

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        height: h,
        width: d[1] * w,
        decoration: BoxDecoration(
            color: col,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged:onchange,
          controller: ctrl,
          style: TextStyle(
            fontFamily: "font1",
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
          decoration: InputDecoration(
              hintText: text
          ),
        ));
  }
}
