import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class QueryWid extends StatelessWidget {

  String querystr="";
  Map<String,dynamic> data={};
  Widget content=Text("default");

  QueryWid({required this.querystr,required this.data, required this.content});

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(querystr),
    variables: data
    ),
    builder:(result, {fetchMore, refetch}) {
      if (result.hasException) {
        return Text(result.exception.toString());
      }
      if (result.isLoading) {
        return CircularProgressIndicator();
      }
      var d = result.data!['getProfById'];
      return content;
    }
    );
    }
  }