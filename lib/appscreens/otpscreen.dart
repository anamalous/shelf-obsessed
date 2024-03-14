import 'package:flutter/material.dart';
import 'package:shelfobsessed/components/numtextbox.dart';
import 'package:shelfobsessed/funcnclass/signupfunc.dart';
import '../components/basicbg.dart';
import '../components/basicbutton.dart';
import '../components/textlabel.dart';
import '../funcnclass/dimensions.dart';
import '../queries/queryfunc.dart';

class OtpScreen extends StatelessWidget {
  var rid="";
  var pw="";
  OtpScreen({super.key,required this.rid,required this.pw});

  final String querystr = '''query verifyUser(\$o:Int!,\$r:Int!,\$p:String!) {
              verifyUser (otp:\$o,rid:\$r,pw:\$p)
            }''';
  var otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return BasicBG(
      align: Alignment.center,
      imgname: "bg5.jpg",
      placed: 140,
      content: Container(
            child: Column(
              children: [
                TextLabel(
                  value: "Shelf Obsessed",
                  col: Colors.grey.shade200,
                  style: FontStyle.normal,
                  size: 30,
                ),
                Container(
                  height: 10,
                ),
                TextLabel(
                    col: Colors.grey.shade200,
                    style: FontStyle.normal,
                    size: 15,
                    value: "You're one step closer to book-worm haven"),
                Container(
                  height: 160,
                ),
                TextLabel(
                    col: Colors.grey.shade200,
                    style: FontStyle.normal,
                    size: 30,
                    value: "VERIFY"),
                Container(
                  height: 40,
                ),
                NumTF(
                    col: Colors.grey.shade200,
                    h: 50,
                    text: "Enter OTP",
                    ctrl: otp,
                    w: 0.8,
                    onchange: (value) {}),
                Container(
                  height: 40,
                ),
                BasicButton(
                  onpress: () async {
                    var res = await getquery(
                        {"o":int.parse(otp.text),"r":int.parse(rid),"p":pw}, querystr, "verifyUser");
                    signupuser(res,context);
                  },
                  text: "Sign Up",
                  w: 200,
                  h: 50,
                )
              ],
            ))
    );
  }
}
