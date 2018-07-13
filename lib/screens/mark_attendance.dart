import 'package:flutter/material.dart';

class MarAttendance extends StatefulWidget {
  @override
  _MarAttendanceState createState() => _MarAttendanceState();
}

class Reason {
  const Reason(this.name);

  final String name;
}

class _MarAttendanceState extends State<MarAttendance> {
  Reason selectedReason;
  List<Reason> Reasons = <Reason>[
    const Reason('Present'),
    const Reason('Leave'),
    const Reason('Holiday')
  ];

  var reason_selected = "";

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          if(reason_selected==""){
            final snackBar = SnackBar(
              content: Text("Please select a reason"),
             /* action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change!
                },
              ),*/
            );

            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
            scaffoldKey.currentState.showSnackBar(snackBar);
          }
          else{

          }
        },
        child: new Icon(Icons.cloud_upload),
      ),
      appBar: new AppBar(
        title: new Text("Mark Your Attendance", ),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Center(
              child: new Container(
                margin: EdgeInsets.all(20.0),
                child: new Text("Select a Reason",style: TextStyle(fontSize: 20.0,)),
              ),
            ),
            new Container(
                margin: EdgeInsets.all(30.0),
                child: new Center(
              child: new DropdownButton<Reason>(
                hint: new Text("Select", style: TextStyle(fontSize: 18.0,),),
                value: selectedReason,
                onChanged: (Reason newValue) {
                  setState(() {
                    selectedReason = newValue;
                    reason_selected = newValue.name;
                  });
                },
                items: Reasons.map((Reason reason) {
                  return new DropdownMenuItem<Reason>(
                    value: reason,
                    child: new Text(
                      reason.name,
                      style: new TextStyle(color: Colors.black, fontSize: 18.0,),
                    ),
                  );
                }).toList(),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
