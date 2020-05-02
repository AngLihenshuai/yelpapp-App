import 'package:flutter/material.dart';
import './tools/splash.dart';

// async get
void main() async {
  runApp(new Yelp());
}

class Yelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yelp DIY APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplishPage(), // name as page works
    );
  }
}