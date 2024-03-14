import 'package:graphql_flutter/graphql_flutter.dart';
import '../funcnclass/graphconf.dart';

dynamic getmutation(Map<String, dynamic> data, String query,String param1, String param2) async {
  var gqc = GraphQLConfiguration();
  var r = await gqc.client
      .mutate(MutationOptions(
      document: gql(query),
      onError: (e) => print(e!.linkException.toString()),
    variables: data));
  var ret= r.data![param1][param2];
  return ret;
}
