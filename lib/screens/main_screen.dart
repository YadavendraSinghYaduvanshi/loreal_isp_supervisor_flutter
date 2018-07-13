import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:loreal_isp_supervisor_flutter/database/database.dart';

class Main_Activity extends StatefulWidget {
  @override
  _Main_ActivityState createState() => _Main_ActivityState();
}

class _Main_ActivityState extends State<Main_Activity>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    _loadCounter();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  var notice_url = "http://gskgtm.parinaam.in/notice/notice.html";
  var visit_date;

  static BuildContext context_global;

  static var profile_name = "test";

  static final profile = new Container(
        height: 150.0,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/nav_bg.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: new Center(
          child: new Column(
            children: <Widget>[
              new Center(
                  child: new Container(
                child: new Center(
                  child: new Image(
                    image: new AssetImage('assets/loreal1.png'),
                    height: 37.2,
                    width: 204.0,
                  ),
                ),
                height: 60.0,
              )),
              new SizedBox(height: 10.0),
              new Text(profile_name,
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.normal)),
            ],
          ),
        ));

  static Text home = new Text("Reports",
      style: new TextStyle(
          color: Colors.blue, fontSize: 20.0, fontStyle: FontStyle.normal));

  static final home_parent = new GestureDetector(
      onTap: () {
        print("Reports clicked");
        Navigator.of(context_global).pop();
        Navigator.of(context_global).pushNamed('/Reports');
      },
      child: new Container(
        child: new Row(children: <Widget>[
          new CircleAvatar(
            backgroundImage: new AssetImage('assets/reports.png'),
            radius: 20.0,
          ),
          new SizedBox(width: 10.0),
          home
        ]),
      ));

  static Text groups = new Text("Mark Attendance",
      style: new TextStyle(
          color: Colors.blue, fontSize: 20.0, fontStyle: FontStyle.normal));

  static final groups_parent = new GestureDetector(
      onTap: () {
        print("Mark Attendance");
        Navigator.of(context_global).pop();
        Navigator.of(context_global).pushNamed('/MarkAttendance');
      },
      child: new Container(
        child: new Row(children: <Widget>[
          new CircleAvatar(
            backgroundImage: new AssetImage('assets/mark_attendance.png'),
            radius: 20.0,
          ),
          new SizedBox(width: 10.0),
          groups
        ]),
      ));

  static Text profile_txt = new Text("Upload Data",
      style: new TextStyle(
          color: Colors.blue, fontSize: 20.0, fontStyle: FontStyle.normal));

  static final profile_parent = new GestureDetector(
      onTap: () {
        Navigator.of(context_global).pop();
        print("Profile clicked");
        //Navigator.of(context_global).pushNamed('/Profile');
      },
      child: new Container(
        child: new Row(children: <Widget>[
          new Image(
            image: new AssetImage('assets/upload_grey.png'),
            height: 30.0,
            width: 30.0,
          ),
          new SizedBox(width: 10.0),
          profile_txt
        ]),
      ));

  static Text sections = new Text("Exit",
      style: new TextStyle(
          color: Colors.blue, fontSize: 20.0, fontStyle: FontStyle.normal));

  static final sections_parent = new GestureDetector(
      onTap: () {
        Navigator.of(context_global).pop();
        print("Sections clicked");
        //Navigator.of(context_global).pushNamed('/DataTest');

        // ignore: implicit_this_reference_in_initializer
        _exitDialog();
      },
      child: new Container(
        child: new Row(children: <Widget>[
          new CircleAvatar(
            backgroundImage: new AssetImage('assets/exit.png'),
            radius: 20.0,
          ),
          new SizedBox(width: 10.0),
          sections
        ]),
      ));

  static var pad = const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0);
  static Padding padding2 = new Padding(
    padding: pad,
    child: home_parent,
  );
  static Padding padding3 = new Padding(
    padding: pad,
    child: groups_parent,
  );
  static Padding padding4 = new Padding(
    padding: pad,
    child: profile_parent,
  );
  static Padding padding5 = new Padding(
    padding: pad,
    child: sections_parent,
  );

  static var children = [
    profile,
    padding2,
    padding3,
    /*padding4,*/
    padding5,
  ];
  static ListView listview = new ListView(children: children);
  Drawer drawer = new Drawer(
    child: listview,
  );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didPopRoute() {
    bool override;

    override = true;
    return new Future<bool>.value(override);
  }

  @override
  Widget build(BuildContext context) {
    context_global = context;
    return new Scaffold(
      drawer: drawer,
      appBar: new AppBar(
        title: new Text("Loreal ISP Supervisor"),
        backgroundColor: Colors.blue,
      ),
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        /*height: 300.0,
        width: 100.0,
        child: new WebviewScaffold(url: notice_url,
          appBar: new AppBar(
            title: new Text("Loreal ISP Supervisor"),
            backgroundColor: Colors.blue,
          ),
          withJavascript: true,
          withLocalStorage: true,
        ),*/
      ),
    );
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    visit_date = prefs.getString('Currentdate');
    notice_url = prefs.getString('Notice');


  }

  static Future<Null> _exitDialog() async {
    return showDialog<Null>(
      context: context_global,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Alert'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Want to exit app'),
                //new Text('or Password'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              color: new Color(0xffEEEEEE),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Ok'),
              color: new Color(0xffEEEEEE),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Login', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  //Loading counter value on start
  _insert(var query) async {
    String path = await initDeleteDb();
    DatabaseISP database = new DatabaseISP();
    await database.open(path);

    await database.create(query);

    await database.close();
  }
}
