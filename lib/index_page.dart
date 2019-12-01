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

  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  
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
                        );
                      }                    
                    }                      
                  }
                )
              ],
            ),
          ),
        ],
      ),)
    );
  }
}

  




