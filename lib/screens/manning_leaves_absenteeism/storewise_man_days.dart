import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DaywiseTimeSpent extends StatefulWidget {
/*  String promoter_id;

  // In the constructor, require a Todo
  DaywiseTimeSpent({Key key, @required this.promoter_id})
      : super(key: key);*/

  @override
  _DaywiseTimeSpentState createState() => _DaywiseTimeSpentState();
}

class _DaywiseTimeSpentState extends State<DaywiseTimeSpent> {
  String user_id, designation, promoter_id;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Daywise Time Spent"),
        ),
        body: Container(
            decoration: new BoxDecoration(
              color: new Color(0xffEEEEEE),
            ),
            child: FutureBuilder<List<DAYWISE_TIME_SPENT>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                //_loadCounter();
                return snapshot.hasData
                    ? (snapshot.data.length>0? StatusList(status: snapshot.data): new Center(child: new Card(child: new Container(margin: EdgeInsets.all(5.0),
                  child: new Text("No Data found", style: TextStyle(fontSize: 20.0),),),),))
                    : Center(child: CircularProgressIndicator());
              },
            )
        ));
  }

  Future<List<DAYWISE_TIME_SPENT>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

    print("Attempting to fetch... DAYWISE_TIME_SPENT ");

    final url = "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/GetAll";

    Map lMap = {
      "Downloadtype": "DAYWISE_TIME_SPENT",
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

List<DAYWISE_TIME_SPENT> parsePhotos(String responseBody) {
  var test = json.decode(responseBody);
  List<DAYWISE_TIME_SPENT> statusList = new List();

  if(test==""){
    return statusList;
  }

  var test1 = json.decode(test);
  var list = test1['DAYWISE_TIME_SPENT'] as List;
  statusList =
  list.map((i) => DAYWISE_TIME_SPENT.fromJson(i)).toList();

  return statusList;

  /* final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promoter>((json) => Promoter.fromJson(json)).toList();*/
}

class DAYWISE_TIME_SPENT {
  final String PROMOTER;
  final int EMP_CD;
  final String JCP_DATE;
  final String IN_TIME;
  final String OUT_TIME;
  final int DURATION_IN_MINUTES;

  DAYWISE_TIME_SPENT(
      {this.PROMOTER,
        this.EMP_CD,
        this.JCP_DATE,
        this.IN_TIME,
        this.OUT_TIME,
        this.DURATION_IN_MINUTES});

  factory DAYWISE_TIME_SPENT.fromJson(Map<String, dynamic> json) {
    return DAYWISE_TIME_SPENT(
      PROMOTER: json['PROMOTER'] as String,
      EMP_CD: json['EMP_CD'] as int,
      JCP_DATE: json['JCP_DATE'] as String,
      IN_TIME: json['IN_TIME'] as String,
      OUT_TIME: json['OUT_TIME'] as String,
      DURATION_IN_MINUTES: json['DURATION_IN_MINUTES'] as int,
    );
  }
}

class StatusList extends StatelessWidget {
  final List<DAYWISE_TIME_SPENT> status;

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
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            "Promoter",
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                        new Expanded(
                          child: new Text(
                            status[index].PROMOTER,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            "JCP Date",
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                        new Expanded(
                          child: new Text(
                            status[index].JCP_DATE,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            "In Time",
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                        new Expanded(
                          child: new Text(
                            status[index].IN_TIME,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            "Out Time",
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                        new Expanded(
                          child: new Text(
                            status[index].OUT_TIME,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            "Duration (In Minutes)",
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                        new Expanded(
                          child: new Text(
                            status[index].DURATION_IN_MINUTES.toString(),
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
