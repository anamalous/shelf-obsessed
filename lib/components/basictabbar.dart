import 'package:flutter/material.dart';

import '../funcnclass/dimensions.dart';

class TabPane extends StatefulWidget {
  final String imgname;
  final List<String> tabs;
  final List<Widget> content;
  final double placed;
  const TabPane(
      {required this.imgname, required this.content, required this.placed,required this.tabs});

  @override
  State<TabPane> createState() => TabState();
}

class TabState extends State<TabPane> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<double> d = dim(context);
    return Scaffold(
      backgroundColor: Colors.black,
        bottomNavigationBar: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: "Feed",
              icon: Icon(Icons.list),
            ),
            Tab(
              text: "Search",
              icon: Icon(Icons.search),
            ),
            Tab(
                text:"Social",
              icon: Icon(Icons.social_distance),
            ),
            Tab(
              text: "Acount",
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
        body:TabBarView(
              physics: ScrollPhysics(
                  parent: NeverScrollableScrollPhysics()
              ),
              controller: _tabController,
              children:widget.content,
            ),);
  }
}
