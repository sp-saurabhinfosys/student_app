import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_app/screens/admin_dashboard.dart';
import 'package:student_app/screens/login.dart';
import 'package:student_app/screens/qr_scanner.dart';
import 'package:student_app/screens/view_attendance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Apani Attendance',
        routes: {
          Dashboard.route: (context) => Dashboard(),
          QrScanner.route:(context)=>QrScanner(),
          ViewAttendance.route:(context)=>ViewAttendance(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Login());
  }
}

// Change subject name in addSubject
//getAllSubject
//QuerySnapshot collectionRef =await  FirebaseFirestore.instance.collection("college").doc(MyStrings.userInfo['cid']).collection(MyStrings.userInfo['dept']).doc(MyStrings.userInfo['dept'].replaceAll(" ", "")).collection("Classes").doc("Sem5CPD").collection('Subjects').get();