import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget{
  final Color col;
  final FontStyle style;
  final double size;
  final String value;
  const TextLabel({required this.col, required this.style, required this.size, required this.value});
  @override
  Widget build(BuildContext context){
    return Text(value,textAlign: TextAlign.left,
      style: TextStyle(color: col,fontFamily: "font1",fontStyle: style,fontSize: size,));
  }
}