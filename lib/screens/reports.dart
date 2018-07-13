import 'package:flutter/material.dart';
import 'package:loreal_isp_supervisor_flutter/utils/card.dart';

class ReportList extends StatefulWidget {
  @override
  _report_listState createState() => _report_listState();
}

class _report_listState extends State<ReportList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Reports"),
      ),
      backgroundColor: new Color(0xffEEEEEE),
      body: ListView(
        children: <Widget>[
          new GestureDetector(
            child:new MyCard(
              title: new Text(
                "Attendance",
                style: new TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic),
              ),
              image: new CircleAvatar(
                backgroundImage: new AssetImage('assets/attendance.png'),
                radius: 30.0,
              ),
            ),
            onTap: () {
              print("attendance");
              Navigator.of(context).pushNamed('/Attendance');
            },
          ),
          new MyCard(
            title: new Text(
              "Promoter Performance",
              style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic),
            ),
            image: new CircleAvatar(
              backgroundImage: new AssetImage('assets/promoter_performance.png'),
              radius: 30.0,
            ),
          ),
          new MyCard(
            title: new Text(
              "Manning / Leaves / Absenteeism",
              style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic),
            ),
            image: new CircleAvatar(
              backgroundImage: new AssetImage('assets/absent.png'),
              radius: 30.0,
            ),
          ),
          new MyCard(
            title: new Text(
              "Self-Visitor Login",
              style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic),
            ),
            image: new CircleAvatar(
              backgroundImage: new AssetImage('assets/visitor_login.png'),
              radius: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
