import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/download_data.dart';
import 'screens/reports.dart';
import 'screens/attendance_report.dart';
import 'screens/login_new.dart';
import 'screens/splash_screen.dart';
import 'screens/mark_attendance.dart';
import 'screens/promoter_list.dart';
import 'screens/attendance.dart';
import 'screens/camera_screen.dart';
import 'screens/store_list.dart';
import 'screens/attendance_screens/attendance_defaulters_with_5days_absent.dart';
import 'screens/attendance_screens/attendance_defaulters_with_3days_absent.dart';
import 'screens/attendance_screens/attendance_tgt_vs_ach_planned_logins.dart';

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
        '/PromoterList': (BuildContext context)=>new PromoterList(),
        '/AttendanceList': (BuildContext context)=>new AttendanceList(),
        '/AttendanceDefaulter5Days': (BuildContext context)=>new AttendanceDefaulter5Days(),
        '/AttendanceDefaulter3Days': (BuildContext context)=>new AttendanceDefaulter3Days(),
        '/AttendanceTgtVsAchPlannedLogins': (BuildContext context)=>new AttendanceTgtVsAchPlannedLogins(),
        '/StoreList': (BuildContext context)=>new StoreList(),
        //'/CameraApp': (BuildContext context)=>new CameraExampleHome(),
      },
      home: new SplashScreen(),
      //home: new LoginNew(),
      //home: new Login(),
    );
  }
}
