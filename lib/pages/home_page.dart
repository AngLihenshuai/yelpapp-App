import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import '../tools/resList.dart';
import '../tools/bottomBar.dart';
import '../tools/appBar.dart';
import '../util/consant.dart';
import 'res_detail.dart';
import '../tools/hotel_list_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/globals.dart' as globals;
// import 'res_details.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // AnimationController animationController;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  double lat, long;
  LocationData currentLocation;
  var location = new Location();
  String error;

  // @override
  // void initState() {
  //   animationController = AnimationController(
  //       duration: const Duration(milliseconds: 1000), vsync: this);
  //   super.initState();
  // }

  // Get Location
  getLoc() async {

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    print(_serviceEnabled);

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }    

    print(_permissionGranted);

    try {
      print("before tracking");
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
        print(error);
      } else {
        print(e);
      }
      currentLocation = null;
    }

    lat = currentLocation.latitude;
    long = currentLocation.longitude;
  }

  // loadNearbyRestaurants
  Future loadNearbyRestaurants() async {
    print("Start to get the location");
    await getLoc();
    print("Already get the location");
    String link = Address.nearby_URL +
        lat.toString() +
        "&longitude=" +
        long.toString() +
        "&limit=5";
    print(link);
    Uri uri = Uri.parse(link);
    var req = new http.Request("GET", uri);
    req.headers['Authorization'] = Address.req_header;
    var res = await req.send();
    List _nearbyRestaurants = [];
    var result = jsonDecode(await res.stream.bytesToString());
    for (var business in result['businesses']) {
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
        decoration: BoxDecoration(color: Colors.indigo[300]),
        child: ListTile(
            onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResDetailPage())),
                  globals.searchname = name,
                  globals.searchid = id,
                },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(Icons.restaurant, color: Colors.white),
            ),
            title: Text(name,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle:
                Text(miles + "miles", style: TextStyle(color: Colors.white)),
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
            appBar: AppUpperBar(),
            body: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text("Restaurants Near You:",
                          style: TextStyle(
                              color: Colors.black45,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w900,
                              fontSize: 30.0)),
                      SizedBox(height: 20.0),
                      FutureBuilder(
                          future:
                              loadNearbyRestaurants(), // future need a future Widget
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
                                return Center(
                                    child: CircularProgressIndicator());
                              case ConnectionState.done:
                                print('Data Loading Done');
                                print(snapshot.hasData);
                                print(snapshot.data);
                                if (!snapshot.hasData) {
                                  return new Container(
                                      child: Text("No data yet"));
                                } else {
                                  print("name");
                                  print(snapshot.data[0]['name']);
                                  return Container(
                                      height: 600.0,
                                      child: ListView.builder(
                                        itemCount: 5,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(top: 8),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return HotelListView(
                                            callback: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResDetailPage()));
                                              globals.searchname =
                                                  snapshot.data[index]['name'];
                                              globals.searchid =
                                                  snapshot.data[index]['id'];
                                            },
                                            hotelData: HotelListData(
                                                imagePath: snapshot.data[index]
                                                    ['image_url'],
                                                titleTxt: snapshot.data[index]
                                                    ['name'],
                                                reviews: snapshot.data[index]
                                                    ['review_count'],
                                                dist: snapshot.data[index]
                                                    ['distance'],
                                                perNight: snapshot.data[index]
                                                    ['price']),
                                            // animation: animation,
                                            // animationController:
                                            //    animationController,
                                          );
                                        },
                                      ));
                                  // return _buildCard(
                                  //     snapshot.data[index]['name'],
                                  //     snapshot.data[index]['distance']
                                  //         .toStringAsFixed(2),
                                  //     snapshot.data[index]['id']);

                                }
                            }
                          })
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavBar(currentIndex: 0)));
  }
}
