import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/otpscreen.dart';
import 'package:shelfobsessed/components/basicdialog.dart';
import 'package:shelfobsessed/components/scrollbg.dart';
import '../components/basicbg.dart';
import '../components/basicbutton.dart';
import '../components/datatextbox.dart';
import '../components/textlabel.dart';
import '../funcnclass/dimensions.dart';
import '../queries/queryfunc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final String querystr = '''query SendOtp(\$e:String!) {
              sendOtp (em:\$e)
            }''';
  var em = TextEditingController();
  var pw=TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return ScrollBG(
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
                    value: "Create your own wonderland"),
                Container(
                  height: 160,
                ),
                TextLabel(
                    col: Colors.grey.shade200,
                    style: FontStyle.normal,
                    size: 30,
                    value: "SIGN UP"),
                Container(
                  height: 40,
                ),
                BasicTF(
                    col: Colors.grey.shade200,
                    h: 50,
                    text: "Enter E-mail",
                    ctrl: em,
                    w: 0.8,
                    onchange: (value) {}),
                Container(
                  height: 20,
                ),
                BasicTF(
                    col: Colors.grey.shade200,
                    h: 50,
                    text: "Create Password",
                    ctrl: pw,
                    w: 0.8,
                    onchange: (value) {}),
                Container(
                  height: 40,
                ),
                BasicButton(
                  onpress: () async {
                    if (em.text.isEmpty || pw.text.isEmpty)
                      dialogprompt(context, "fields are left empty");
                    else if(!EmailValidator.validate(em.text))
                      dialogprompt(context, "enter a valid email");
                    else if(pw.text.length<8)
                      dialogprompt(context, "password length should be 8 characters");
                    else {
                      var res = await getquery(
                          {"e": em.text}, querystr, "sendOtp");
                      print("rid:$res");
                      if (int.parse(res.toString()) == -1)
                        dialogprompt(context, "account already exists");
                      else
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (BuildContext context) =>
                                OtpScreen(rid: res.toString(), pw: pw.text)));
                    }
                  },
                  text: "Get OTP",
                  w: 200,
                  h: 50,
                )
              ],
            ))
    );
  }
}
