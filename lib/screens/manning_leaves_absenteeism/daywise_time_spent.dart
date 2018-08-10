import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StorewiseManDays extends StatefulWidget {
/*  String promoter_id;

  // In the constructor, require a Todo
  StorewiseManDays({Key key, @required this.promoter_id})
      : super(key: key);*/

  @override
  _StorewiseManDaysState createState() => _StorewiseManDaysState();
}

class _StorewiseManDaysState extends State<StorewiseManDays> {
  String user_id, designation, promoter_id;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Storewise Man Days"),
        ),
        body: Container(
          decoration: new BoxDecoration(
            color: new Color(0xffEEEEEE),
          ),
          child: new Column(
            children: <Widget>[
              new Card(
                child: new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          "Store",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      new Expanded(
                        child: new Center(
                          child: new Text(
                            "Planned",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Center(
                          child: new Text(
                            "Achievement",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Expanded(
                  child: FutureBuilder<List<STOREWISE_MANNED_DAYS>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  //_loadCounter();
                  return snapshot.hasData
                      ? (snapshot.data.length > 0
                          ? StatusList(status: snapshot.data)
                          : new Center(
                              child: new Card(
                                child: new Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: new Text(
                                    "No Data found",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ))
                      : Center(child: CircularProgressIndicator());
                },
              )),
            ],
          ),
        ));
  }

  Future<List<STOREWISE_MANNED_DAYS>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

    print("Attempting to fetch... STOREWISE_MANNED_DAYS ");

    final url = "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/GetAll";

    Map lMap = {
      "Downloadtype": "STOREWISE_MANNED_DAYS",
      "Username": user_id,
      "per1": designation,
      "per2": user_id,
      "per3": "0",
      "per4": "0",
      "per5": "0",
    };

    String lData = json.encode(lMap);
    Map<String, String> lHeaders = {};
    lHeaders = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    //http.post(url, body: lData, headers: lHeaders).then((response) {
    var response = await http.post(url, body: lData, headers: lHeaders);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    // Use the compute function to run parsePhotos in a separate isolate
    return compute(parsePhotos, response.body);
  }
}

List<STOREWISE_MANNED_DAYS> parsePhotos(String responseBody) {
  var test = JSON.decode(responseBody);

  List<STOREWISE_MANNED_DAYS> statusList = new List();

  if (test == "") {
    return statusList;
  }

  var test1 = json.decode(test);
  var list = test1['STOREWISE_MANNED_DAYS'] as List;

  statusList = list.map((i) => STOREWISE_MANNED_DAYS.fromJson(i)).toList();

  return statusList;

  /* final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promoter>((json) => Promoter.fromJson(json)).toList();*/
}

class STOREWISE_MANNED_DAYS {
  final int Store_cd, PLANNED, ACHIEVEMENT;
  final String STORE;

  STOREWISE_MANNED_DAYS(
      {this.Store_cd, this.PLANNED, this.ACHIEVEMENT, this.STORE});

  factory STOREWISE_MANNED_DAYS.fromJson(Map<String, dynamic> json) {
    return STOREWISE_MANNED_DAYS(
      Store_cd: json['Store_cd'] as int,
      PLANNED: json['PLANNED'] as int,
      ACHIEVEMENT: json['ACHIEVEMENT'] as int,
      STORE: json['STORE'] as String,
    );
  }
}

class StatusList extends StatelessWidget {
  final List<STOREWISE_MANNED_DAYS> status;

  StatusList({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: status.length,
      itemBuilder: (context, index) {
        return new Card(
            child: new GestureDetector(
          onTap: () {
            print("attendance");
            /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceDataUploadstatus(promoter_id: status[index].JCP_DATE),
                  ),
                );*/
          },
          child: new Container(
            margin: EdgeInsets.all(10.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Text(
                    status[index].STORE,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                new Expanded(
                    child: new Center(
                  child: new Text(
                    status[index].PLANNED.toString(),
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal),
                  ),
                )),
                new Expanded(
                    child: new Center(
                  child: new Text(
                    status[index].ACHIEVEMENT.toString(),
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal),
                  ),
                )),
              ],
            ),
          ),
        ));
      },
    );
  }
}
