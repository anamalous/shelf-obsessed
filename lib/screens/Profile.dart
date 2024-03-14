import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelfobsessed/screens/uploadpfpscreen.dart';
class Profile extends StatelessWidget{
  final int uid;
  Profile({required this.uid});
  late var pref=SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context){
    var q='''query(\$usid:String!){
      getProfById(uid:\$usid) {
    pfile
  }
}
    ''';
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:Query(
          options:QueryOptions(
          document: gql(q),
            variables: {
            "usid":uid
            }
          ),
          builder:(result, {fetchMore, refetch}) {
            var d=result.data!['getProfById'];
            return Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(20, 40, 0, 0),
              height: 1000,
                child:
                    Column(
              children:[
                Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image:NetworkImage("http://192.168.43.165:8000/media/"+d['pfile']),fit: BoxFit.fitWidth,),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                            border: Border.all(color: Colors.black,width: 5)
                    ),
                    width: 100,
                    height: 100,
                ),
                TextButton(child:Text("change"),
                onPressed:
                () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UploadPFP())))
            ])
            );
          }
        )
    );
  }
}