import 'package:graphql_flutter/graphql_flutter.dart';
import '../funcnclass/graphconf.dart';

dynamic getquery(String query,String param) async {
  var gqc = GraphQLConfiguration();
  var r = await gqc.client
      .query(QueryOptions(document: gql(query)));
  return (r.data![param]);
}
