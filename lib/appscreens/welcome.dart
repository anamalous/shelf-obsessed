import 'package:flutter/material.dart';
import 'package:shelfobsessed/components/imgcarousel.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/appscreens/login.dart';
import 'package:shelfobsessed/appscreens/signup.dart';
import '../components/basicbutton.dart';
import '../components/basicbg.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicBG(
        imgname: "black.jpg",
        placed: 0,
        align: Alignment.center,
        content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextLabel(
                col: Colors.white,
                size: 20,
                style: FontStyle.normal,
                value: "Discover your favourites",
              ),
              Container(
                height: 30,
              ),
              ImageCaro(
                imgurls: ["lw.jpg", "1984.jpg", "tci.jpg","tfr.jpg"],
              ),
              Container(
                height: 20,
              ),
              BasicButton(
                w: 250,
                h: 50,
                onpress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                },
                text: "Login",
              ),
              Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextLabel(
                          style: FontStyle.normal,
                          size: 15,
                          col: Colors.white,
                          value: "  Dont have an Account?",
                        ),
                        TextButton(
                          child: TextLabel(col: Colors.white,size: 15,style: FontStyle.normal,value: "Sign Up",),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignUpScreen()));
                          },
                        )
                      ]))
            ]));
  }
}
