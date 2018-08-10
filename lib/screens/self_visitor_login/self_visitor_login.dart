import 'package:flutter/material.dart';
import 'package:loreal_isp_supervisor_flutter/utils/card_simple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelfVisitorLogin extends StatefulWidget {
  @override
  _SelfVisitorLoginState createState() => _SelfVisitorLoginState();
}

class _SelfVisitorLoginState extends State<SelfVisitorLogin> {

  String user_id, designation;

  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();

    super.initState();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //visit_date = prefs.getString('CURRENTDATE');
    user_id = prefs.getString('Userid');
    designation = prefs.getString('Designation');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Self-Visitor Login"),
      ),
      backgroundColor: new Color(0xffEEEEEE),
      body: ListView(
        children: <Widget>[
          new GestureDetector(
            child:new MyCardSimple(
              title: new Text(
                "No of visitor logins till previous day",
                style: new TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic),
              ),
            ),
            onTap: () {
            Navigator.of(context).pushNamed('/VisitorLogin');
            },
          ),
          new GestureDetector(
            child:  new MyCardSimple(
              title: new Text(
                "No of days marked worked (Calculated even if he has done one visitor login for any day)",
                style: new TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic),
              ),
            ),
            onTap: (){
              Navigator.of(context).pushNamed('/NoDaysWorked');
            },
          ),

          new GestureDetector(
            child: new MyCardSimple(
              title: new Text(
                "Time Spent",
                style: new TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic),
              ),

            ),
            onTap: (){
              Navigator.of(context).pushNamed('/VisitorTimeSpent');
            },
          ),
        ],
      ),
    );
  }
}
