import 'package:flutter/material.dart';
import 'appscreens/splash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final link= HttpLink("http://192.168.43.165:8000/graphql/");
ValueNotifier<GraphQLClient> client=ValueNotifier(
  GraphQLClient(
    cache: GraphQLCache(
      possibleTypes:{
        'userById':{'id','uname','email','passw','dob','gen','ans','wl','read','pid','recents','bio','req','friend'}
      }
    ),
    link: link,
  )
);
class MainApp extends StatelessWidget{
  const MainApp({super.key});
  @override
  Widget build(BuildContext context){
    return GraphQLProvider(
      client: client,
        child:MaterialApp(
          theme: ThemeData(
            unselectedWidgetColor: Colors.white
          ),
          debugShowCheckedModeBanner: false,
          home: Splash(),
          ),
    );
  }
}