import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
static HttpLink httpLink = HttpLink("http://192.168.43.165:8000/graphql/");

GraphQLClient client = GraphQLClient(
  cache: GraphQLCache(),
  link: httpLink,
);
}