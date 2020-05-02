import 'package:flutter/material.dart';
import 'address.dart';
import 'globals.dart' as globals;
import '../index.dart';
import 'item2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../tools/appBar.dart';
import '../tools/bottomBar.dart';

class ResDetailPage extends StatefulWidget {
  @override
  ResDetailPageState createState() => new ResDetailPageState();
}

class ResDetailPageState extends State<ResDetailPage> {
  int index = 1;
  String searchRes;
  List names = new List();
  final TextEditingController _filter = new TextEditingController();
  List filteredNames = new List(); // names filtered by search text
  // Icon _searchIcon = new Icon(Icons.search);
  // Widget _appBarTitle = new Text('Search Example');
  // Future<Map> businessDetails;

  // @override
  // void initState() {
  //   this.build(context);
  //   super.initState();
  // }

  Widget buildName(String name, String id) {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(children: <Widget>[
        new Text(name,
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500)),
        SizedBox(height: 50.0),
        new Text(id,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500)),
      ]),
    ));
  }

  
  // Widget _buildDrawer() {
  //   return Drawer(
  //       child: ListView(
  //     children: <Widget>[
  //       DrawerHeader(
  //         child: Row(
  //           children: <Widget>[
  //             Image.asset('assets/Logo.png', width: 70.0, height: 70.0),
  //             SizedBox(width: 25.0),
  //             Text("Hi, Ryan",
  //                 style: TextStyle(
  //                     fontFamily: "Rajdhani",
  //                     fontSize: 20.0,
  //                     fontWeight: FontWeight.bold))
  //           ],
  //         ),
  //       ),
  //       ListTile(
  //           title: Text("Vibrational Levels",
  //               style: TextStyle(fontFamily: "Rajdhani")),
  //           onTap: () {
  //             // Navigator.push(
  //             //     context, MaterialPageRoute(builder: (context) => VibPage()));
  //           }),
  //       ListTile(
  //           title: Text("Haptic Patterns",
  //               style: TextStyle(fontFamily: "Rajdhani")),
  //           onTap: () {
  //             // Navigator.push(context,
  //             //     MaterialPageRoute(builder: (context) => HapticPage()));
  //           }),
  //       ListTile(
  //           title: Text("Rerun Tutorial",
  //               style: TextStyle(fontFamily: "Rajdhani")),
  //           onTap: () {
  //             // Navigator.push(context,
  //             //     MaterialPageRoute(builder: (context) => TutorialPage()));
  //           }),
  //       ListTile(
  //           title: Text("Settings", style: TextStyle(fontFamily: "Rajdhani")),
  //           onTap: () {
  //             // Navigator.push(context,
  //             //     MaterialPageRoute(builder: (context) => SettingsPage()));
  //           }),
  //       ListTile(title: Text("Help", style: TextStyle(fontFamily: "Rajdhani"))),
  //       ListTile(
  //           title: Text("About Us", style: TextStyle(fontFamily: "Rajdhani"))),
  //     ],
  //   ));
  // }

  // Widget _buildBar(BuildContext context) {
  //   return new AppBar(
  //     centerTitle: true,
  //     title: _appBarTitle,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUpperBar(),
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            child: new FutureBuilder(
              future: main(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ));
                } else if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      new Text(snapshot.data['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.blue[600])),
                      const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                      Container(
                        child: new Image(
                            image: NetworkImage(snapshot.data['image']),
                            height: 300,
                            width: 500,
                            fit: BoxFit.fill),
                        constraints: BoxConstraints(maxHeight: 250),
                      )
                    ],
                  );
                } else {
                  return new Container();
                }
              },
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15.0)),
          Container(
            child: new FutureBuilder(
              future: main(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasData) {
                  print('has data: ' + snapshot.data['food'].toString());
                  return Expanded(
                      child: SizedBox(
                    height: 200.0,
                    width: 600,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomListItemTwo(
                            thumbnail: Image.network(
                                'https://lh3.googleusercontent.com/tTI-TsvK6Gn_9PiUD_aiIAXiC-4uSYC5SBif_IFXgPIVgdCkA0BthkZskqp6ww_90ikUiIaII_Ipktl40J4Fn8Dh1FvmSP2lZXl_hbMoEzDRUbVmRp50xsKRK77M3aCaeS3y6Qqk',
                                height: 100,
                                fit: BoxFit.fill),
                            title: snapshot.data['food'][index]['name'],
                            point: snapshot.data['food'][index]['sentiment']
                                .toStringAsFixed(2),
                            recommand: 'Highly recommand',
                          );
                        }),
                  ));
                } else {
                  print('no data');
                  return new Container();
                }
              },
            ),
          ),
        ],
      )),
      // drawer: _buildDrawer(),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  //   @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: _buildBar(context),
  //     body: Center(
  //       child: Column(
  //         children: <Widget>[
  //           new Container(
  //             child: Text(businessDetails['name']),)
  //         ],)

  //     ),
  //     drawer: _buildDrawer(),
  //     bottomNavigationBar: _buildBottomNav(),
  //   );
  // }

  main() async {
    String link = "https://api.yelp.com/v3/businesses/" + globals.searchid;
    // String link = "https://food-extraction2--sunyu912.repl.co/getreview/" +
    //     globals.searchid;
    print('get link: ' + link);
    Uri uri = Uri.parse(link);

    var req = new http.Request("GET", uri);
    req.headers['Authorization'] = Address.req_header;
    var res = await req.send();

    var obj = jsonDecode(await res.stream.bytesToString());
    Map details = {};
    details['name'] = obj['name'];
    details['image'] = obj['image_url'];

    String reviewLink = Address.review_url_address + obj['url'];
    Uri reviewURI = Uri.parse(reviewLink);
    var req2 = new http.Request("GET", reviewURI);
    var res2 = await req2.send();
    var reviews = jsonDecode(await res2.stream.bytesToString());
    print('reviews: ' + reviews.toString());
    details['food'] = new List();
    for (var i = 0; i < 5; i++) {
      details['food'].add(reviews[i]);
    }
    print('details: ' + details.toString());
    return details;    
  }
}
