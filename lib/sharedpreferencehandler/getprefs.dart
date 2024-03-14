import 'package:shared_preferences/shared_preferences.dart';

 Future<Map<dynamic,dynamic>> getprefs() async{
   var d={};
  var prefs=await SharedPreferences.getInstance();
  await prefs.reload();
  d["loggedin"]=await prefs.getInt("loggedin");
  d["uid"]=await prefs.getInt("uid");
  return d;
}
