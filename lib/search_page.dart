import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;
import 'res_details.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  // Search Bar 
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  int index = 1;
  bool currentlySearching = false;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _searchBarTitle = new Text('Input your food type here');

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        //this._searchIcon = new Icon(Icons.close);
        this._searchBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(hintText: 'Search...'),
        );
        currentlySearching = true;
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._searchBarTitle = new Text('Search');
        _filter.clear();
        currentlySearching = false;
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: _searchBarTitle, actions: [
      new IconButton(
        alignment: Alignment.center,
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    ]);
  }

  // Build Search Page 
  @override
  Widget build(BuildContext context) {
    return Container(child: Scaffold(
      appBar: _buildBar(context),
      body:Center(
        child: Text('Search Page'),
      )      
    )
  );}
}

