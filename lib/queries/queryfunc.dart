import 'package:graphql_flutter/graphql_flutter.dart';
import '../funcnclass/graphconf.dart';

dynamic getquery(Map<String, dynamic> data, String query,String param) async {
  var gqc = GraphQLConfiguration();
  var r = await gqc.client
      .query(QueryOptions(document: gql(query), variables: data));
  return (r.data![param]);
}
