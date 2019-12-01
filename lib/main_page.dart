import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'index_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    currentPage = tabBodies[currentIndex];
    return Container(
      child: Scaffold(
        appBar: _buildBar(context),
        // body: Container(
        //   child: Center(
        //     child: Text('Home Page'),
        //   )
        // ),
        body: currentPage,
        drawer: _buildDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: bottomTabs,
          onTap: (index){
            setState(() {
              currentIndex=index;
              currentPage=tabBodies[currentIndex]; 
            });
          },
        ),
      )
    );
  }
  
  // Top Nav Bar
  Widget _appBarTitle = new Text('Yelp APP'); 
  
  Widget _buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: _appBarTitle);
  }

  // Bottom Nav Bar 
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon:Icon(CupertinoIcons.home),
      title:Text('Home')
    ),
    BottomNavigationBarItem(
      icon:Icon(CupertinoIcons.search),
      title:Text('Search')
    ),
    BottomNavigationBarItem(
      icon:Icon(CupertinoIcons.profile_circled),
      title:Text('Proflie')
    ),
  ];
  final List tabBodies = [
    IndexPage(),
    SearchPage(),
    ProfilePage(),    
  ];
  int currentIndex = 0;
  var currentPage; 

  // Drawer
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                SizedBox(width: 25.0),
                Text("Hi,Customer",
                    style: TextStyle(
                    fontFamily: "Rajdhani",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ListTile(
            title: Text("Recents", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => VibPage()));
            }),
          ListTile(
            title: Text("Favorites", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => HapticPage()));
            }),
          ListTile(
            title:
                Text("User Settings", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => TutorialPage()));
            }),
          ListTile(
            title: Text("Help", style: TextStyle(fontFamily: "Rajdhani")),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SettingsPage()));
            }),
          ListTile(
            title: Text("About Us", style: TextStyle(fontFamily: "Rajdhani"))),
          ListTile(
            title: Text("Log In", style: TextStyle(fontFamily: "Rajdhani"))),
        ],
      )
    );
  }  
}