import 'package:flutter/material.dart';
import '../tools/bottomBar.dart';
import '../tools/appBar.dart';



class ProfilePage extends StatefulWidget {
  //ProfilePage({Key key, this.title, this.time}) : super(key: key);
  //final String title;
  //final int time;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUpperBar(),
      body: Center(child: Text("Profile")),
      bottomNavigationBar: BottomNavBar(currentIndex:2)
    );
  }
}
