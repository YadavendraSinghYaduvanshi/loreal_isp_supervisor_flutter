import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceDefaulter5Days extends StatefulWidget {
/*  String promoter_id;

  // In the constructor, require a Todo
  AttendanceDefaulter5Days({Key key, @required this.promoter_id})
      : super(key: key);*/

  @override
  _AttendanceDefaulter5DaysState createState() =>
      _AttendanceDefaulter5DaysState();
}

class _AttendanceDefaulter5DaysState
    extends State<AttendanceDefaulter5Days> {
  String user_id, designation, promoter_id;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title:
          new Text("Defaulters with 5 days absent"),
        ),
        body: Container(
          decoration: new BoxDecoration(
            color: new Color(0xffEEEEEE),
          ),
          child: new Column(
            children: <Widget>[
              new Card(
                child: new Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0
                  ),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Center(
                          child: new Text(
                            "Promoters",
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Expanded(
                  child: FutureBuilder<List<ABSENT_DEFAULTER_FIVEDAYS>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      //_loadCounter();
                      return snapshot.hasData
                          ? (snapshot.data.length>0? StatusList(status: snapshot.data): new Center(child: new Card(child: new Container(margin: EdgeInsets.all(5.0),
                        child: new Text("No Data found", style: TextStyle(fontSize: 20.0),),),),))
                          : Center(child: CircularProgressIndicator());
                    },
                  ))
            ],
          ),
        ));
  }

  Future<List<ABSENT_DEFAULTER_FIVEDAYS>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

    print("Attempting to fetch... PROMOTER_LIST ");

    final url = "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/GetAll";

    Map lMap = {
      "Downloadtype": "ABSENT_DEFAULTER_FIVEDAYS",
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

List<ABSENT_DEFAULTER_FIVEDAYS> parsePhotos(String responseBody) {
  var test = JSON.decode(responseBody);
  List<ABSENT_DEFAULTER_FIVEDAYS> statusList = new List();
  if(test==""){
    return statusList;
  }
  var test1 = json.decode(test);
  var list = test1['ABSENT_DEFAULTER_FIVEDAYS'] as List;

  statusList = list.map((i) => ABSENT_DEFAULTER_FIVEDAYS.fromJson(i)).toList();

  return statusList;

  /* final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promoter>((json) => Promoter.fromJson(json)).toList();*/
}

class ABSENT_DEFAULTER_FIVEDAYS {
  final String PROMOTER;

  ABSENT_DEFAULTER_FIVEDAYS(
      {this.PROMOTER});

  factory ABSENT_DEFAULTER_FIVEDAYS.fromJson(Map<String, dynamic> json) {
    return ABSENT_DEFAULTER_FIVEDAYS(
      PROMOTER: json['PROMOTER'] as String,
    );
  }
}

class StatusList extends StatelessWidget {
  final List<ABSENT_DEFAULTER_FIVEDAYS> status;

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
                        child: new Center(
                          child: new Text(
                            status[index].PROMOTER,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
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
