import 'package:flutter/material.dart';
import 'package:shelfobsessed/components/basicdialog.dart';
import 'package:shelfobsessed/sharedpreferencehandler/setprefs.dart';

import '../appscreens/details.dart';

signupuser(String res, BuildContext context) async {
  if (res == "expired")
    dialogprompt(context, "OTP expired please retry");
  else if (res == "invalid")
    dialogprompt(context, "OTP incorrect");
  else {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailsScreen(uid: int.parse(res))));
  }
}
