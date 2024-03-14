import 'dart:convert';

dynamic jsondec(String s){
  s=s.replaceAll("{","{\"");
  s=s.replaceAll(": ", "\":\"");
  s=s.replaceAll(", ", "\",\"");
  s=s.replaceAll("}", "\"}");
  s=s.replaceAll("}\",\"{", "},{");
  s=s.replaceAll("\\n", "\n");
  dynamic j=jsonDecode(s);
  return j;
}

dynamic jsondecsumm(String s){
  String s1= s;
  int i=s1.indexOf("summary");
  var s2=jsondec(s.substring(0,i-2)+"}");
  s2['summary']=s.substring(i+9,s.length-2);
  return s2;
}

dynamic jsondecpost(String s){
  String s1= s;
  int i=s1.indexOf("content");
  var s2=jsondec(s.substring(0,i-2)+"}");
  s2['content']=s.substring(i+9,s.length-2);
  return s2;
}
dynamic jsondecparam(s,p){
  int i=s.indexOf(p);
  var s2=jsondec(s.substring(0,i-2)+"}");
  var l=s.substring(i+p.length+3,s.length-2);
  s2[p]=l.toString().split(",");
  return s2;
}
