import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VisitorTimeSpent extends StatefulWidget {
/*  String promoter_id;

  // In the constructor, require a Todo
  VisitorTimeSpent({Key key, @required this.promoter_id})
      : super(key: key);*/

  @override
  _VisitorTimeSpentState createState() =>
      _VisitorTimeSpentState();
}

class _VisitorTimeSpentState extends State<VisitorTimeSpent> {
  String user_id, designation, promoter_id;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Visitor Time Spent"),
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
                          "Visiter",
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
                            "Visit Date",
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
                            "Total Minutes",
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
                  child: FutureBuilder<List<VISITOR_TIME_SPENT>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      //_loadCounter();
                      return snapshot.hasData
                          ?
                      (snapshot.data.length>0? StatusList(status: snapshot.data): new Center(child: new Card(child: new Container(margin: EdgeInsets.all(5.0),
                        child: new Text("No Data found", style: TextStyle(fontSize: 20.0),),),),))
                          : Center(child: CircularProgressIndicator());
                    },
                  ))
            ],
          ),
        ));
  }

  Future<List<VISITOR_TIME_SPENT>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

    print("Attempting to fetch... VISITOR_TIME_SPENT ");

    final url = "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/GetAll";

    Map lMap = {
      "Downloadtype": "VISITOR_TIME_SPENT",
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

List<VISITOR_TIME_SPENT> parsePhotos(String responseBody) {
  var test = JSON.decode(responseBody);
  List<VISITOR_TIME_SPENT> statusList = new List();

  if(test==""){
    return statusList;
  }

  var test1 = json.decode(test);
  var list = test1['VISITOR_TIME_SPENT'] as List;
   statusList =
  list.map((i) => VISITOR_TIME_SPENT.fromJson(i)).toList();

  return statusList;

  /* final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promoter>((json) => Promoter.fromJson(json)).toList();*/
}

class VISITOR_TIME_SPENT {
  final String VISITOR;
  final int EMP_ID;
  final String VISIT_DATE;
  final int TOTAL_MINUTES;

  VISITOR_TIME_SPENT(
      {this.VISITOR, this.EMP_ID, this.VISIT_DATE, this.TOTAL_MINUTES});

  factory VISITOR_TIME_SPENT.fromJson(Map<String, dynamic> json) {
    return VISITOR_TIME_SPENT(
      VISITOR: json['VISITOR'] as String,
      EMP_ID: json['EMP_ID'] as int,
      VISIT_DATE: json['VISIT_DATE'] as String,
      TOTAL_MINUTES: json['TOTAL_MINUTES'] as int,

    );
  }
}

class StatusList extends StatelessWidget {
  final List<VISITOR_TIME_SPENT> status;

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
              },
              child: new Container(
                margin: EdgeInsets.all(10.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        status[index].VISITOR,
                        style: new TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    new Expanded(
                        child: new Center(
                          child: new Text(
                            status[index].VISIT_DATE.toString(),
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        )),
                    new Expanded(
                        child: new Center(
                          child: new Text(
                            status[index].TOTAL_MINUTES.toString(),
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
