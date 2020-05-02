import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './res_detail.dart';
import '../util/consant.dart';
import '../util/foods.dart';
import '../util/globals.dart' as globals;
import '../tools/ratingStar.dart';
import '../tools/bottomBar.dart';
import '../tools/appBar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // with AutomaticKeepAliveClientMixin<SearchPage> {
  // define search bar
  final TextEditingController _searchControl = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search, color: Colors.black);
  // IconButton _searchButton =  new IconButton(icon:Icon(Icons.search, color: Colors.black), onPressed: () { });
  String _searchText = "";
  bool currentlySearching = false;
  String _hintText = 'Search';

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._hintText = 'Searching...';
        currentlySearching = true;
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._hintText = 'Search';
        _searchControl.clear();
        currentlySearching = false;
      }
    });
  }

  _SearchPageState() {
    _searchControl.addListener(() {
      if (_searchControl.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchControl.text;
        });
      }
    });
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data[0].length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  title: Text(snapshot.data[0][index]),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResDetailPage())),
                    globals.searchname = snapshot.data[0][index],
                    globals.searchid = snapshot.data[1][index],
                  },
                );
              },
            );
          } else {
            return new Container();
          }
        });
  }

  Widget overlayContainer() {
    if (currentlySearching == true) {
      return Container(
        color: Colors.white,
        child: Container(height: 600, child: _buildList()),
      );
    } else {
      return Container(
          child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Hot Search",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 6.0),
        Container(
            child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          itemCount: hot_search_foods == null ? 0 : hot_search_foods.length,
          itemBuilder: (BuildContext context, int index) {
            Map food = hot_search_foods[index];
            return ListTile(
              title: Text(
                "${food['name']}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              leading: CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage(
                  "${food['img']}",
                ),
              ),
              trailing: Text(r"$10"),
              subtitle: Row(
                children: <Widget>[
                  SmoothStarRating(
                    starCount: 1,
                    color: Colors.yellow[600],
                    allowHalfRating: true,
                    rating: 5.0,
                    size: 12.0,
                  ),
                  SizedBox(width: 6.0),
                  Text(
                    "5.0 (23 Reviews)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              onTap: () {},
            );
          },
        ))
      ]));
    }
  }

  // Main Function
  _getBusList() async {
    await getLoc();
    print(lat);
    print(long);
    String link = Address.search_URL +
        _searchText +
        "&latitude=" +
        lat.toString() +
        "&longitude=" +
        long.toString();
    Uri uri = Uri.parse(link);

    var req = new http.Request("GET", uri);
    req.headers['Authorization'] = Address.req_header;
    var res = await req.send();
    var obj = jsonDecode(await res.stream.bytesToString());
    List name = [];
    List id = [];
    for (var term in obj['businesses']) {
      print('business names: ' + term['name']);
      print('business id: ' + term['id']);
      name.add(term['name']);
      id.add(term['id']);
    }
    return [name, id];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppUpperBar(), //AppUpperBar(),
        body: Container(
            child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              Card(
                elevation: 6.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: _hintText,
                      suffixIcon: IconButton(
                        icon: _searchIcon,
                        onPressed: _searchPressed,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                    controller: _searchControl,
                  ),
                ),
              ),
              SizedBox(height: 10),
              overlayContainer()
            ],
          ),
        )),
        bottomNavigationBar: BottomNavBar(currentIndex: 1));
  }
}