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
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                    ),
                    Text("Yelp App",
                        style: TextStyle(
                            color: Colors.white,
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                  ),
                  Text(
                    "A DIY Yelp APP",
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