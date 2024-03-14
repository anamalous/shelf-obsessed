import 'package:flutter/material.dart';
import 'package:shelfobsessed/appscreens/details.dart';
import 'package:shelfobsessed/components/basicdialog.dart';
import 'package:shelfobsessed/queries/queryfunc.dart';
import '../appscreens/maintabs.dart';
import '../sharedpreferencehandler/setprefs.dart';

loginuser(res,BuildContext context,String un) async {
  var q='''query(\$u:Int!) {
              userById(uid:\$u) {
                    uname
              }
          }''';

  if (res == null) {
    print("error");
  }
  else if (res==-1)
    dialogprompt(context, "incorrect password");
  else if (res==-2)
    dialogprompt(context, "user does not exist");
  else {
    var un = await getquery({"u": res}, q, "userById");
    if (un["uname"] == "") {
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (BuildContext context) => DetailsScreen(uid: res)));
    }
    else {
      await setprefs(1,res);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (BuildContext context) => TabsScreen(uid: res)));
    }
  }

}