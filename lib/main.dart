import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'http://192.168.0.74/werkzeug/public/api/data_tool1';
  List data;
  Timer timer;

  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = JSON.decode(response.body);
      data = extractdata;
    });
  }

  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(new Duration(seconds: 2), (Timer timer) async {
      this.makeRequest();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Tool Data'),
        ),
        body: new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int i) {
              return new ListTile(
                title: new Text('Tool 1 Temperature is : ''${data[i]["temp1"]}' ' and tool 2 is: ''${data[i]["temp2"]}'),
              );
            }
        )
    );
  }
}
