import 'package:shared_preferences/shared_preferences.dart';

Future<void> setprefs(loggedin,uid) async{
  var prefs=await SharedPreferences.getInstance();
  await prefs.setInt("loggedin",loggedin);
  await prefs.setInt("uid",uid);
  await prefs.commit();
}
Future<void> setloggedin(loggedin) async{
  var prefs=await SharedPreferences.getInstance();
  await prefs.setInt("loggedin",loggedin);
}

Future<void> setuser(uid) async{
  var prefs=await SharedPreferences.getInstance();
  await prefs.setInt("uid",uid);

}