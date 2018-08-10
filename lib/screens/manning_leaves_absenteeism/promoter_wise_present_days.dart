import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PromoterWisePresentDays extends StatefulWidget {
/*  String promoter_id;

  // In the constructor, require a Todo
  PromoterWisePresentDays({Key key, @required this.promoter_id})
      : super(key: key);*/

  @override
  _PromoterWisePresentDaysState createState() =>
      _PromoterWisePresentDaysState();
}

class _PromoterWisePresentDaysState extends State<PromoterWisePresentDays> {
  String user_id, designation, promoter_id;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Promoter wise present days till previous day"),
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
                          "Promoter",
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
                            "JCP Date",
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
                            "Attendance",
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
                  child: FutureBuilder<List<PROMOTER_WISE_PRESENT_DAYS>>(
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

  Future<List<PROMOTER_WISE_PRESENT_DAYS>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

    print("Attempting to fetch... PROMOTER_WISE_PRESENT_DAYS ");

    final url = "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/GetAll";

    Map lMap = {
      "Downloadtype": "PROMOTER_WISE_PRESENT_DAYS",
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

List<PROMOTER_WISE_PRESENT_DAYS> parsePhotos(String responseBody) {
  var test = JSON.decode(responseBody);
  List<PROMOTER_WISE_PRESENT_DAYS> statusList = new List();

  if(test==""){
    return statusList;
  }

  var test1 = json.decode(test);
  var list = test1['PROMOTER_WISE_PRESENT_DAYS'] as List;
  statusList=
      list.map((i) => PROMOTER_WISE_PRESENT_DAYS.fromJson(i)).toList();

  return statusList;

  /* final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promoter>((json) => Promoter.fromJson(json)).toList();*/
}

class PROMOTER_WISE_PRESENT_DAYS {
  final String PROMOTER;
  final int EMP_CD;
  final String JCP_DATE;
  final String ATTENDANCE;

  PROMOTER_WISE_PRESENT_DAYS(
      {this.PROMOTER, this.EMP_CD, this.JCP_DATE, this.ATTENDANCE});

  factory PROMOTER_WISE_PRESENT_DAYS.fromJson(Map<String, dynamic> json) {
    return PROMOTER_WISE_PRESENT_DAYS(
      PROMOTER: json['PROMOTER'] as String,
      EMP_CD: json['EMP_CD'] as int,
      JCP_DATE: json['JCP_DATE'] as String,
      ATTENDANCE: json['ATTENDANCE'] as String,
    );
  }
}

class StatusList extends StatelessWidget {
  final List<PROMOTER_WISE_PRESENT_DAYS> status;

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
                    status[index].PROMOTER,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                new Expanded(
                    child: new Center(
                  child: new Text(
                    status[index].JCP_DATE.toString(),
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontStyle: FontStyle.normal),
                  ),
                )),
                new Expanded(
                    child: new Center(
                  child: new Text(
                    status[index].ATTENDANCE.toString(),
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
