import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'attendance_screens/attendance_data_upload_status_screen.dart';

class PromoterList extends StatefulWidget {
  @override
  _PromoterListState createState() => _PromoterListState();
}

class _PromoterListState extends State<PromoterList> {

  String user_id, designation;

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

    //fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Promoter List"),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Promoter>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            //_loadCounter();
            return snapshot.hasData
                ? PromotersList(promoter: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      )
    );
  }

  Future<List<Promoter>> fetchData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

    print("Attempting to fetch... PROMOTER_LIST ");

    final url =
        "http://lipromo.parinaam.in/Webservice/Liwebservice.svc/GetAll";

    Map lMap = {
      "Downloadtype": "PROMOTER_LIST",
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
     /*   print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
     *//* var test = JSON.decode(response.body);

      var test1 = json.decode(test);
      var list = test1['PROMOTER_LIST'] as List;
      List<Promoter> promoterList = list.map((i) => Promoter.fromJson(i)).toList();
*//*
      //List<Promoter> data = json.decode(test)['PROMOTER_LIST'];

      //return promoterList;

      // Use the compute function to run parsePhotos in a separate isolate
      return compute(parsePhotos, response.body);
    });*/

    // Use the compute function to run parsePhotos in a separate isolate
    return compute(parsePhotos, response.body);
  }
}

// A function that will convert a response body into a List<Photo>
List<Promoter> parsePhotos(String responseBody) {

  var test = JSON.decode(responseBody);

  var test1 = json.decode(test);
  var list = test1['PROMOTER_LIST'] as List;
  List<Promoter> promoterList = list.map((i) => Promoter.fromJson(i)).toList();

  return promoterList;

 /* final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Promoter>((json) => Promoter.fromJson(json)).toList();*/
}

class Promoter {
  final String USERNAME;
  final String PROMOTER;

  Promoter({this.USERNAME, this.PROMOTER});

  factory Promoter.fromJson(Map<String, dynamic> json) {
    return Promoter(
      USERNAME: json['USERNAME'] as String,
      PROMOTER: json['PROMOTER'] as String,
    );
  }
}

class PromotersList extends StatelessWidget {
  final List<Promoter> promoter;

  PromotersList({Key key, this.promoter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: promoter.length,
      itemBuilder: (context, index) {
        return new Card(
          child: new GestureDetector(
            onTap: () {
              print("attendance");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceDataUploadstatus(promoter_id: promoter[index].USERNAME),
                ),
              );
            },
            child: new Container(
              margin: EdgeInsets.all(10.0),
              child: new Text(promoter[index].PROMOTER,style: new TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontStyle: FontStyle.normal),),
            ),
          )
        );
      },
    );
  }
}


