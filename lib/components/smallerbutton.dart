import 'package:flutter/material.dart';
class SmallerButton extends StatefulWidget{
  final Function() onpress;
  final String text;
  final double w;
  final double h;
  const SmallerButton({required this.onpress,required this.text,required this.w,required this.h});

  @override
  State<SmallerButton> createState() => _SmallerButtonState();
}

class _SmallerButtonState extends State<SmallerButton> {
  var a="";
  @override
  Widget build(BuildContext context){
    return Container(
        height: widget.h,
        width: widget.w,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200,width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child:TextButton(onPressed: (){
          setState(() {a="o";});
          widget.onpress();
        }, child: Text(widget.text,style: TextStyle(color: Colors.white,fontFamily: "font1",fontSize: 16),)));
  }
}
