import 'package:flutter/material.dart';
import '../util/consant.dart';
import '../util/globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../tools/appBar.dart';
import '../tools/bottomBar.dart';
import '../tools/item.dart';

class ResDetailPage extends StatefulWidget {
  @override
  ResDetailPageState createState() => new ResDetailPageState();
}

class ResDetailPageState extends State<ResDetailPage> {
  String searchRes;
  List names = new List();
  List filteredNames = new List();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUpperBar(),
      body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          child: Center(
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
                                  color: Colors.black54)),
                          const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                          Container(
                              height: 300,
                              width: 500,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: new Image(
                                    image: NetworkImage(snapshot.data['image']),
                                    fit: BoxFit.cover,
                                  ))),
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
                                thumbnail: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.asset("assets/food1.jpeg",
                                        height: 100, fit: BoxFit.cover)),
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
          ))),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }

  main() async {
    String link = Address.search_by_id_URL + globals.searchid;
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
