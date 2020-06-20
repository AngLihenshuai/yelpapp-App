import 'package:flutter/material.dart';
import './tools/splash.dart';
import 'package:splashscreen/splashscreen.dart';
import 'index.dart';

// async get
void main() async {
  runApp(new Yelp());
}

class Yelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dishcovery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplishPage(), // name as page works
    );
  }
}