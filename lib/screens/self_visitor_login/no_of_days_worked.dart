import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NoDaysWorked extends StatefulWidget {
/*  String promoter_id;

  // In the constructor, require a Todo
  NoDaysWorked({Key key, @required this.promoter_id})
      : super(key: key);*/

  @override
  _NoDaysWorkedState createState() =>
      _NoDaysWorkedState();
}

class _NoDaysWorkedState extends State<NoDaysWorked> {
  String user_id, designation, promoter_id;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("No Of Days Worked"),
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
                            "Worked days",
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
                  child: FutureBuilder<List<NO_OF_DAYS_WORKED>>(
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

  Future<List<NO_OF_DAYS_WORKED>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

    print("Attempting to fetch... NO_OF_DAYS_WORKED ");

    final url = "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/GetAll";

    Map lMap = {
      "Downloadtype": "NO_OF_DAYS_WORKED",
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

List<NO_OF_DAYS_WORKED> parsePhotos(String responseBody) {
  var test = JSON.decode(responseBody);
  List<NO_OF_DAYS_WORKED> statusList = new List();

  if(test==""){
    return statusList;
  }
  var test1 = json.decode(test);
  var list = test1['NO_OF_DAYS_WORKED'] as List;
   statusList =
  list.map((i) => NO_OF_DAYS_WORKED.fromJson(i)).toList();

  return statusList;

  /* final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promoter>((json) => Promoter.fromJson(json)).toList();*/
}

class NO_OF_DAYS_WORKED {
  final String VISITOR;
  final int EMP_ID;
  final int WORKED_DAYS;

  NO_OF_DAYS_WORKED(
      {this.VISITOR, this.EMP_ID, this.WORKED_DAYS});

  factory NO_OF_DAYS_WORKED.fromJson(Map<String, dynamic> json) {
    return NO_OF_DAYS_WORKED(
      VISITOR: json['VISITOR'] as String,
      EMP_ID: json['EMP_ID'] as int,
      WORKED_DAYS: json['WORKED_DAYS'] as int,

    );
  }
}

class StatusList extends StatelessWidget {
  final List<NO_OF_DAYS_WORKED> status;

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
                            status[index].WORKED_DAYS.toString(),
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
