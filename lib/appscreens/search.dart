import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/bookbutton.dart';
import 'package:shelfobsessed/components/datatextbox.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';
import '../funcnclass/jsondecode.dart';

class SearchScreen extends StatefulWidget {
  final int uid;
  SearchScreen({super.key,required this.uid});
  @override
  State<SearchScreen> createState() => SearchState();
}

class SearchState extends State<SearchScreen> {

  late Future<dynamic> res=Future((){});
  late String searched="";
  late String column="n";
  String reset="";
  final String querystr='''query(\$v:String!,\$c:String!){
              bookByCol(val:\$v,col:\$c){
                        id
                        bname
                        cid
                        author
              }
  }
  ''';
  var s = TextEditingController();
  List n=["n","a","g","y","i"];
  List<bool> l = [true, false, false,false,false];

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return BasicBG(
      align: Alignment.center,
      imgname: "bg3.jpg",
      placed: 70,
      content: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextLabel(
                col: Colors.grey.shade200,
                style: FontStyle.normal,
                size: 30,
                value: " Search "),
            Container(
              height: 20,
            ),
            BasicTF(h: 50, text: "Search by...", ctrl: s, w: 0.95,
                col: Colors.grey.shade200,
                onchange:(value){
                  setState(() {
                    searched=value;
                  });
                }),
            Container(
              height: 20,
            ),
            ToggleButtons(
                color: Colors.white,
                selectedColor: Colors.lightBlueAccent,
                selectedBorderColor: Colors.lightBlueAccent,
                borderColor: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                children: <Widget>[
                  Text("  Name   ",style: TextStyle(fontFamily: "font1",fontSize: 18)),
                  Text("  Author  ",style: TextStyle(fontFamily: "font1",fontSize: 18),),
                  Text("  Genre  ",style: TextStyle(fontFamily: "font1",fontSize: 18)),
                  Text("   Year   ",style: TextStyle(fontFamily: "font1",fontSize: 18)),
                  Text("   ISBN   ",style: TextStyle(fontFamily: "font1",fontSize: 18)),
                ],
                isSelected: l,
                onPressed: (int index) {
                  setState(() {
                    l = [false, false, false,false,false];
                    l[index] = !l[index];
                    column=n[index];
                  });
                }),
            Container(height: 20,),
            Container(
                alignment: Alignment.center,
                child:
                Query(
                    options: QueryOptions(
                        document: gql(querystr),
                        variables: {"v":searched,"c":column}
                    ),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return CircularProgressIndicator();
                      }
                      List<dynamic> data = jsondec(result.data!['bookByCol'].toString());
                      return Container(height: d[0]*0.6,
                      child: SingleChildScrollView(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for(var i in data)
                            BookButton(bookname: i["bname"], cid: int.parse(
                                i["cid"]), au: i["author"],bid:int.parse(i["id"]),uid: widget.uid,)
                        ],
                      )),);
                    })
            )
          ],
        ),),
    );
  }
}
