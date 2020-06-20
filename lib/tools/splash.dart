import 'package:flutter/material.dart';
import 'dart:async';
import '../pages/home_page.dart';


class SplishPage extends StatefulWidget {
  @override
  _SplishPageState createState() => _SplishPageState();
}

class _SplishPageState extends State<SplishPage> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 6),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Container(height:150),
            Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                  child: Image.asset(
                    "assets/Dishcoverylogo.png",
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
            Expanded(flex: 1,
             child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[                    
                    Text("Dishcovery",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 40.0,
                            fontFamily: "Rajdhani"))
                  ],
                ))),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                  ),
                  Text(
                    "Find the best food",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: "Rajdhani"),
                  )
                ],
              ),
            )            
          ])
        ],
      ),
    );
  }
}