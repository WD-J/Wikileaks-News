import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:verbal_expressions/verbal_expressions.dart';
import 'package:flutter/foundation.dart';
import 'package:pigment/pigment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as p;

// For when you come back: The api doesn't include all article types, and not the actual article either.
// What you've developed so far is the front page design.
// You'd also need to know how to integrate pagination.
// I believe this could be done just by chaning the url and running getData(); again. Url example: faktisk.no/page="2"

// Article Blue: 0xFF0461ff
// Header Blue:  0xFF1169ff

bool _GridToggle = true;

MaterialColor HeaderBlue = const MaterialColor(
  0xFF1169ff,
  <int, Color>{
    50: Color(0xFF1169ff),
    100: Color(0xFF1169ff),
    200: Color(0xFF1169ff),
    300: Color(0xFF1169ff),
    400: Color(0xFF1169ff),
    500: Color(0xFF1169ff),
    600: Color(0xFF1169ff),
    700: Color(0xFF1169ff),
    800: Color(0xFF1169ff),
    900: Color(0xFF1169ff),
  },
);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WikiLeaks News',
      theme: ThemeData(
        primarySwatch: HeaderBlue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getBody();
  }

  List linkList = List();
  List titleList = List();
  List dateList = List();
  List descriptionList = List();

  void getBody() async {
    /*
      linkList.length = 0;
      titleList.length = 0;
      dateList.length = 0;
      descriptionList.length = 0;
     */
    // is loading is true
    final response = await http.get('https://wikileaks.org/-News-.html');
    if (response.statusCode == 200) {
      var document = parse(response.body);

      var links = document.querySelectorAll('.title > a');
      for (var body in links) {
        linkList.add(body.outerHtml.toString().split("\"")[1]);
        setState(() {
          // is loading false?
        });
      }
      var titles = document.querySelectorAll('.title > a');
      for (var body in titles) {
        titleList.add(body.innerHtml);
        setState(() {});
      }
      var dates = document.querySelectorAll('.timestamp');
      for (var body in dates) {
        dateList.add(body.innerHtml);
        setState(() {});
      }
      var descriptions = document.querySelectorAll('.introduction > p');
      for (var body in descriptions) {
        descriptionList.add(body.text);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Pigment.fromString("2F3338"),
        appBar: AppBar(
          backgroundColor: Pigment.fromString("2F3338"),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("WikiLeaks News",
              style: TextStyle(
                fontFamily: 'times',
                color: Colors.white,
              )),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Stack(
            children: <Widget>[
              ListView.builder(
                  // itemCount: finalList.length,
                  itemCount: titleList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItem();
                  }),
            ],
          ),
        ));
  }

  Widget _buildItem() {
    var debateVariable =
        linkList.removeAt(0).toString().replaceAll(".html", "");
    var fakeUrl = "https://wikileaks.org/" + linkList.removeAt(0);
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 0,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.white.withAlpha(70),
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // insert method for opening comment section
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DebatePage(
                                      debateChooser: debateVariable,
                                    ),
                              ));
                        },
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, bottom: 10, top: 10),
                                child: Text(
                                  titleList.removeAt(0),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'times',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15, bottom: 10, right: 5),
                                child: Text(
                                  descriptionList
                                      .removeAt(0)
                                      .toString()
                                      .replaceAll("\n", ""),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'times',
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: dateList.isEmpty ? 0 : 20,
                                bottom: dateList.isEmpty ? 0 : 5),
                            child: Text(
                              dateList.isEmpty ? "" : dateList.removeAt(0),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'times',
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
                          // linkList.removeAt(0)
                          InkWell(
                            splashColor: Colors.black.withAlpha(125),
                            onTap: () async {
                              // insert method for opening comment section
                              if (await canLaunch(fakeUrl)) {
                                launch(fakeUrl);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: linkList.isEmpty ? 0 : 20,
                                  bottom: linkList.isEmpty ? 0 : 5),
                              child: Text(
                                linkList.isEmpty ? "" : "Go to article",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'times',
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              color: Pigment.fromString("2F3338"),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      linkList.length = 0;
      titleList.length = 0;
      dateList.length = 0;
      descriptionList.length = 0;
      getBody();
    });
  }
}

class DebatePage extends StatefulWidget {
  final String debateChooser;
  DebatePage({Key key, @required this.debateChooser}) : super(key: key);

  @override
  _DebatePageState createState() => _DebatePageState();
}

TextEditingController postController = TextEditingController();

/*
void postMethod() async {
  await Firestore.instance.collection('comments').document(widget.debateChooser).collection('comment').document().setData({
    'comment': TextEditingController.text,
  });
}
*/

List<String> names = ["Helle", "Anonymous", "Username"];

class _DebatePageState extends State<DebatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pigment.fromString("2F3338"),
      appBar: AppBar(
        backgroundColor: Pigment.fromString("2F3338"),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Comment Section",
            style: TextStyle(
              fontFamily: 'times',
              color: Colors.white,
            )),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('comments')
                .document(widget.debateChooser)
                .collection('comment')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.data.documents.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'No commenters to be found!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'times',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Want to be the first?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'times',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(
                              'Type your comment below.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'times',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: TextField(
                              onTap: () {
                                return;
                              },
                              controller: postController,
                              cursorColor: Colors.white,
                              style: TextStyle(
                                  fontFamily: 'times',
                                  fontSize: 25,
                                  color: Pigment.fromString("#2F3338")),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 25, left: 25),
                                fillColor: Pigment.fromString("#565F6C"),
                                filled: true,
                                hintText: "Comment",
                                hintStyle: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(names.removeAt(0),
                                    style: TextStyle(
                                      fontFamily: 'times',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    )),
                              ),
                              Text(document['comment'],
                                  style: TextStyle(
                                    fontFamily: 'times',
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
