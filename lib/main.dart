import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/main_screen.dart';
import 'screens/download_data.dart';
import 'screens/reports.dart';
import 'screens/attendance_report.dart';
import 'screens/login_new.dart';
import 'screens/splash_screen.dart';
import 'screens/mark_attendance.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My CPM',
      routes: <String, WidgetBuilder>{
        '/MainPage': (BuildContext context)=>new Main_Activity(),
        '/Download': (BuildContext context)=>new DownloadData(),
        '/Reports': (BuildContext context)=>new ReportList(),
        '/Attendance': (BuildContext context)=>new Attendance(),
        '/Login': (BuildContext context)=>new LoginNew(),
        '/MarkAttendance': (BuildContext context)=>new MarAttendance(),
      },
      home: new SplashScreen(),
      //home: new LoginNew(),
      //home: new Login(),
    );
  }
}
