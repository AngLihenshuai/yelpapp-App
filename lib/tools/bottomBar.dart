import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/search_page.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  BottomNavBar({
    Key key,
    this.currentIndex,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState(currentIndex);
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex;
   _BottomNavBarState(this.currentIndex);
  @override
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home), title: Text('home')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search), title: Text('search')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled), title: Text('profile')),
  ];
  final List tabBodies = [MyHomePage(), SearchPage(), ProfilePage()];
  var currentPage;

  @override
  void initState() {
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      items: bottomTabs,
      onTap: (index) {
        int currentIndex = index;
        currentPage = tabBodies[currentIndex];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => currentPage));
      },
    );
  }
}