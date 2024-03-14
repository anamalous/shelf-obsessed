import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/components/botwbooks.dart';
import 'package:shelfobsessed/components/datatextbox.dart';
import 'package:shelfobsessed/components/textlabel.dart';
import '../funcnclass/dimensions.dart';
import '../components/basicbg.dart';
import '../funcnclass/jsondecode.dart';

class AddBotw extends StatefulWidget {
  final bcid,name,uid;
  AddBotw({super.key,required this.bcid,required this.name, required this.uid});
  @override
  State<AddBotw> createState() => SearchState();
}

class SearchState extends State<AddBotw> {

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

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return BasicBG(
      align: Alignment.center,
      imgname: "bg3.jpg",
      placed: 60,
      content: Container(
        width: d[1],
          padding: EdgeInsets.all(8),
          child: Column(
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
              BasicTF(h: 50, text: "Search", ctrl: s, w: 0.95,
                  col: Colors.grey.shade200,
                  onchange:(value){
                    setState(() {
                      searched=value;
                    });
                  }),
              Container(height: 20,),
              Container(
                width: d[1]*0.95,
                height: d[0]*0.7,
                  alignment: Alignment.center,
                  child:Query(
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
                        List<dynamic> d = jsondec(result.data!['bookByCol'].toString());
                        return SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for(var i in d)
                              BookButton(bookname: i["bname"], cid: int.parse(
                                  i["cid"]), au: i["author"],bid:int.parse(i["id"]),bcid: int.parse(widget.bcid),uid:widget.uid,name:widget.name)
                          ],
                        ));;
                      }),

              )
            ],
          )),
    );
  }
}
