import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './pages/home_page.dart';
import './pages/profile_page.dart';
import './pages/search_page.dart';
import './tools/bottomBar.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home), title: Text('home')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search), title: Text('search')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled), title: Text('profile')),
  ];
  final List tabBodies = [MyHomePage(), ProfilePage(), SearchPage()];
  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // AppUpperBar
        appBar: AppBar(title: Text("yelp diy")),
        body: currentPage,
        bottomNavigationBar: BottomNavBar()
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   currentIndex: currentIndex,
        //   items: bottomTabs,
        //   onTap: (index) {
        //     setState(() {
        //       currentIndex = index;
        //       currentPage = tabBodies[currentIndex];
        //     });
        //   },
        // )
        );
  }
}