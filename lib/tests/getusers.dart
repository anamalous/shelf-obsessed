import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class newpage extends StatelessWidget{

  final String allUsers="""query {
     allUsers{
        name
      }
      }
      """;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Query(
      options: QueryOptions(
        document: gql(allUsers),
            variables: {
          'id':2
            },
            pollInterval: Duration(seconds: 10)
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return Text("loading...");
        }
        List d=result.data!["allUsers"];
        return ListView.builder(
          itemCount: d.length,
            itemBuilder:
            (context,index){
              return Text(d[index]['name']);
            }
        );
      }
    )
    );
  }
}