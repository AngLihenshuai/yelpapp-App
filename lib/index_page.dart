import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;
import 'res_details.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  
  // Inital page state 
  String _searchText = "";

   _IndexPageState() {
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

  // Main Function
  _getBusList() async {
    getLoc();
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

  // Build Main List 
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

  // loadNearbyRestaurants
  Future loadNearbyRestaurants() async {
    print("Use this function");
    await getLoc();
    String link = "https://api.yelp.com/v3/businesses/search?term=restaurants&latitude=" + lat.toString() + "&longitude=" + long.toString() + "&limit=5";
    Uri uri = Uri.parse(link);
    var req = new http.Request("GET", uri);
    req.headers['Authorization'] =
        'Bearer endKOtxDzmquiDBFQKImIss0K8oBAsSaatw84j7Z_mdayis_dfwdaAeiAGgARwPu7I9i3rYzQcNTVA8JL05phkq7O7elOZ5fLYjliuElh5ac8QyeJ9Lsdn871yE2XXYx';
    var res = await req.send();
    List _nearbyRestaurants = [];
    var result = jsonDecode(await res.stream.bytesToString());
    for(var business in result['businesses']) {
      _nearbyRestaurants.add(business);
    }
    print('nearby restaurants: ' + _nearbyRestaurants.toString());
    return _nearbyRestaurants;
  }

  Widget _buildCard(String name, String dist, id) {
    String miles = (double.parse(dist) / 1000).toStringAsFixed(2);
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.redAccent),
        child: ListTile(
          onTap: () => {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResDetailPage())),
                globals.searchname = name,
                globals.searchid = id,
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(Icons.restaurant, color: Colors.white),
            ),
            title: Text(
              name,
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            subtitle: Text(miles + "miles",style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.white, size: 15.0)),
      ),
    );
  }
  
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

  // Build Container
  Widget overlayContainer() {
   if (currentlySearching == true) {
    return Container(
      color: Colors.white,
      child: _buildList());
    } else 
      return Container(child:Text("Please insert your type of food in search bar"));
  }

  // Build Page 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldstate,
        resizeToAvoidBottomPadding: false,
        // appBar: _buildBar(context),
        body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text("Restaurants Near You:",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15.0)),
                SizedBox(height: 20.0),
                FutureBuilder(
                  future: loadNearbyRestaurants(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        print('Not start yet');
                        return Text('Not start yet');
                      case ConnectionState.active:
                        print('active');
                        return Text('active');
                      case ConnectionState.waiting:
                        print('Waiting');
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        print('Data Loading Done');
                        print (snapshot.hasData);
                        print (snapshot.data);
                        if (!snapshot.hasData) {                        
                          return new Container(child:Text("No data yet"));
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildCard(snapshot.data[index]['name'], snapshot.data[index]['distance'].toStringAsFixed(2), snapshot.data[index]['id']);
                            },
                        );}                    
                    }                      
                  })
              ],
            ),
          ),
        //overlayContainer(),
        ],
      ),
       
          )
        );
  }
}

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:Center(
//         child: Text('Test Main Page'),
//       )
//     );
//   }
  




