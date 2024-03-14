import 'package:flutter/material.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/datatextbox.dart';
import 'package:shelfobsessed/components/scrollbg.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/queries/queryfunc.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';
import '../funcnclass/loginfunc.dart';
import '../components/basicdialog.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatelessWidget {
  final String querystr = '''query(\$e:String!,\$pa:String!){
                                  loginUser(em:\$e,pw:\$pa) 
                              }
                          ''';

  var em = TextEditingController();
  var pas = TextEditingController();

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
                value: "Making Your World Brighter, One Page At A Time"),
            Container(
              height: 140,
            ),
            TextLabel(
                col: Colors.grey.shade200,
                style: FontStyle.normal,
                size: 30,
                value: "LOGIN "),
            Container(
              height: 40,
            ),
            BasicTF(
              h: 50,
              text: "Enter E-mail",
              ctrl: em,
              w: 0.8,
              onchange: (value) {},
              col: Colors.grey.shade200,
            ),
            Container(
              height: 20,
            ),
            BasicTF(
              h: 50,
              text: "Enter Password",
              ctrl: pas,
              w: 0.8,
              onchange: (value) {},
              col: Colors.grey.shade200,
            ),
            Container(
              height: 20,
            ),
            TextLabel(
                col: Colors.grey.shade200,
                style: FontStyle.normal,
                size: 15,
                value: "Forgot Your Password?"),
            Container(
              height: 40,
            ),
            BasicButton(
              onpress: () async {
                if (em.text.isEmpty || pas.text.isEmpty)
                  dialogprompt(context, "fields are left empty");
                else if(!EmailValidator.validate(em.text))
                  dialogprompt(context, "enter a valid email");
                else {
                  var res = await getquery(
                      {"e": em.text, "pa": pas.text}, querystr, "loginUser");
                  loginuser(res, context, em.text);
                }
              },
              text: "Login",
              w: 200,
              h: 50,
            )
          ],
        )));
  }
}
