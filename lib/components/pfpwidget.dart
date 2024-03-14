import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shelfobsessed/funcnclass/dimensions.dart';

class PFPWidget extends StatelessWidget{
  var uid;
  var side;
  PFPWidget({super.key,required this.uid,required this.side});
  var pfpquery = '''query(\$u:Int!) {
                      profByUid(uid:\$u)
                  }''';
  @override
  Widget build(BuildContext context){
    var d=dim(context);
    return Query(
        options: QueryOptions(
            document: gql(pfpquery),
            variables: {"u": uid}),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return CircularProgressIndicator();
          }
          var url =
          Uri.parse(result.data!["profByUid"]);
          return Container(
            height: side,
            width: side,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, width: 2),
                borderRadius:
                BorderRadius.circular(side),
                image: DecorationImage(
                    image: NetworkImage(
                        "http://192.168.43.165:8000/media/$url"),
                    fit: BoxFit.cover)),
          );
        });
  }
}