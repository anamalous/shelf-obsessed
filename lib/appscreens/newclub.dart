import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/appscreens/maintabs.dart';
import 'package:shelfobsessed/components/basicbutton.dart';
import 'package:shelfobsessed/components/datatextbox.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import 'package:shelfobsessed/mutations/mutfunc.dart';
import 'package:shelfobsessed/queries/queryfunc.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';
import '../funcnclass/jsondecode.dart';
import '../funcnclass/loginfunc.dart';

class NewClub extends StatelessWidget {
  final int uid;

  List mem=[];
  NewClub({super.key, required this.uid});

  final String querystr = '''mutation(\$u:Int!,\$n:String!,\$m:[Int!]){
                                  createBookclub(uid:\$u,bcname:\$n,mems:\$m){
                                  s
                              }
                          }''';
  final String friendquery = '''query(\$u:Int!){
                                userById(uid:\$u){
                                    uname
                                    friend
                                }
                             }''';

  var name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return BasicBG(
        align: Alignment.topLeft,
        imgname: "bg3.jpg",
        placed: 60,
        content: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextLabel(
                    col: Colors.grey.shade200,
                    style: FontStyle.normal,
                    size: 25,
                    value: "Create New Club"),
                Container(
                  height: 40,
                ),
                BasicTF(
                  h: 50,
                  text: "Enter name",
                  ctrl: name,
                  w: 0.8,
                  onchange: (value) {},
                  col: Colors.grey.shade200,
                ),
                Container(
                  height: 20,
                ),
                TextLabel(
                    col: Colors.white,
                    style: FontStyle.normal,
                    size: 20,
                    value: "Add Friends"),
                Container(
                    height: d[0] * 0.3,
                    child: Query(
                        options: QueryOptions(
                            document: gql(friendquery), variables: {"u": uid}),
                        builder: (result, {fetchMore, refetch}) {
                          if (result.hasException) {
                            return Text(result.exception.toString());
                          }
                          if (result.isLoading) {
                            return CircularProgressIndicator();
                          }
                          var k = jsondecparam(
                              result.data!['userById'].toString(), "friend");
                          print(k["friend"]);
                          if (k["friend"].toString() == "[ul]" ||
                              k["friend"].toString() == "[]") {
                            return TextLabel(
                                col: Colors.white,
                                style: FontStyle.normal,
                                size: 30,
                                value: "No Friends Yet");
                          } else {
                            print(k["friend"]);
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var i in k["friend"])
                                    Query(
                                        options: QueryOptions(
                                            document: gql(friendquery),
                                            variables: {"u": int.parse(i)}),
                                        builder: (result,
                                            {fetchMore, refetch}) {
                                          if (result.hasException) {
                                            return Text(
                                                result.exception.toString());
                                          }
                                          if (result.isLoading) {
                                            return CircularProgressIndicator();
                                          }
                                          var user = jsondecparam(
                                              result.data!['userById']
                                                  .toString(),
                                              "friend");
                                          return TextButton(
                                              onPressed: () {
                                                if(mem.contains(int.parse(i))){
                                                  print("lol");
                                                }
                                                else{
                                                  mem.add(int.parse(i));
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(user["uname"].toString()+" added"),
                                                  duration: Duration(milliseconds: 500),
                                                ));
                                                print(mem);
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: d[1],
                                                height: d[0]*0.05,
                                                child: TextLabel(
                                                  col: Colors.white,
                                                  size: 20,
                                                  style: FontStyle.normal,
                                                  value: user["uname"],
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white)),
                                              ));
                                        }),
                                ],
                              ),
                            );
                          }
                        })),
                BasicButton(
                  onpress: () async {
                    print(name.text);
                    var res = await getmutation({"u":uid,"n":name.text,"m":mem}, querystr, "createBookclub", "s");
                    if(res=="done"){
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>TabsScreen(uid: uid)));
                    }
                  },
                  text: "Create",
                  w: d[1] * 0.4,
                  h: d[0] * 0.06,
                )
              ],
            )));
  }
}
