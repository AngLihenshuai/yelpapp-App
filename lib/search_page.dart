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

  // Initial the search page 
  String _searchText = "";

  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }
   
  // Search Bar 
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  bool currentlySearching = false;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _searchBarTitle = new Text('Input your food type here');

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
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

  // Get Location 
  double lat, long;
  LocationData currentLocation;
  var location = new Location();
  String error;
  getLoc() async {
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      currentLocation = null;
    }
    lat = currentLocation.latitude;
    long = currentLocation.longitude;
  } 

  // Layout container
  Widget _buildList() {
    return new FutureBuilder(
      future: _getBusList(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator()
          );
        } else if(snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data[0].length,
            itemBuilder: (BuildContext context, int index) {
            return new ListTile(
              title: Text(snapshot.data[0][index]),
              onTap: () => {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ResDetailPage())),
              globals.searchname = snapshot.data[0][index],
              globals.searchid = snapshot.data[1][index],
            },
          );
        },);
        } else {
        return new Container();
        }
      }
    );
  }

  Widget overlayContainer() {
    if (currentlySearching == true) {
      return Container(
        color: Colors.white,
        child: _buildList(),
      );
    } else
      return Container();
  }

  // Main Function
  _getBusList() async {
    await getLoc();
    print(lat);
    print(long);
    String link = "https://api.yelp.com/v3/autocomplete?text=" + _searchText + "&latitude=" + lat.toString() + "&longitude=" + long.toString();
    Uri uri = Uri.parse(link);

    var req = new http.Request("GET", uri);
    req.headers['Authorization'] =
        'Bearer endKOtxDzmquiDBFQKImIss0K8oBAsSaatw84j7Z_mdayis_dfwdaAeiAGgARwPu7I9i3rYzQcNTVA8JL05phkq7O7elOZ5fLYjliuElh5ac8QyeJ9Lsdn871yE2XXYx';
    var res = await req.send();
    var obj = jsonDecode(await res.stream.bytesToString());
    List name = [];
    List id = [];
    for (var term in obj['businesses']) {
      print('business names: ' + term['name']);
      print('business id: ' + term['id']);
      name.add(term['name']);
      id.add(term['id']);}
    return [name, id];
  }

  // Build Search Page 
  @override
  Widget build(BuildContext context) {
    return Container(child: Scaffold(
      appBar: _buildBar(context),
      body:Center(
        child: overlayContainer()
      )      
    )
  );}
}

