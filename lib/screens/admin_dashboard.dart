import 'package:flutter/material.dart';
import 'package:student_app/custom_widgets/dashboard_tile.dart';
import 'package:student_app/screens/view_attendance.dart';
import 'package:student_app/utils/database_helper.dart';
import 'package:student_app/utils/utils.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  static String route = "Dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _scanBarcode = 'Unknown';
  int getPresent(QuerySnapshot q){
    int pre = 0;
    for(int i=0;i<q.docs.length;i++)
    {
      if(q.docs[i]['present'])
        pre++;
    }
    return pre;
  }
  Future getSubjects() async {
    QuerySnapshot collectionRef = await FirebaseFirestore.instance
        .collection("college")
        .doc(MyStrings.userInfo['collegeId'])
        .collection(MyStrings.userInfo['departmentName'])
        .doc(MyStrings.userInfo['departmentName'].replaceAll(" ", ""))
        .collection("Classes")
        .doc(MyStrings.userInfo['className'].replaceAll(" ", ""))
        .collection("Subjects")
        .get();

    setState(() {});
    print("Length ");
    print(collectionRef.docs.length);
    int length = collectionRef.docs.length;
    MyStrings.subjectList.clear();
    for (int i = 0; i < length; i++) {
      MyStrings.subjectList.add(collectionRef.docs[i]['subject']);
      //print(collectionRef.docs[i]['subject']);
    }


    print(MyStrings.subjectList);
  }

  Future getAttendanceInfo() async {
    MyStrings.stData.clear();
    for(int sub = 0;sub<MyStrings.subjectList.length;sub++) {
      QuerySnapshot a = await FirebaseFirestore.instance
          .collection("college")
          .doc(MyStrings.userInfo['collegeId'])
          .collection(MyStrings.userInfo['departmentName'])
          .doc(MyStrings.userInfo['departmentName'].replaceAll(" ", ""))
          .collection("Classes")
          .doc(MyStrings.userInfo['className'].replaceAll(" ", ""))
          .collection("Students").doc(MyStrings.userInfo['enrollment']).collection(MyStrings.subjectList[sub])
          .get();
      MyStrings.stData.add({"${MyStrings.subjectList[sub]}":[getPresent(a),a.docs.length]});
      print("${MyStrings.subjectList[sub]}${a.docs.length}");
    }
    setState(() {});
    print(MyStrings.stData);
  }
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      print("${MyStrings.userInfo}");
      DocumentSnapshot d = await FirebaseFirestore.instance.collection("qr").doc(barcodeScanRes.toString()).get();
      print(d["departmentName"]);
      await DatabaseHelper().giveAttendance(

        date: "${d["date"]}${d["startingTime"]}${d["endingTime"]}",
        enrollment: "${MyStrings.userInfo["enrollment"]}",
        cid: "${MyStrings.userInfo['collegeId']}",
        dept: "${MyStrings.userInfo["departmentName"]}",
        myClass: "${MyStrings.userInfo["className"]}",
        subject: "${d["subject"]}",
      );
      setState(() {

      });
    } on Exception {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print(_scanBarcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.whiteColor,
        drawer: Drawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(MyStrings.adminText),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Row(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardTile(borderColor:MyColors.greenColor,title: "Add",image: MyImages.addImage,onClick: (){

                  },),
                  DashboardTile(borderColor:MyColors.pinkColor,title: "${MyStrings.takeAttendanceText}",image: MyImages.attendanceImage,onClick: (){


                  },),
                ],
              ),
              SizedBox(height: 15,),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardTile(
                      borderColor: MyColors.yellowColor,
                      title: "Give Attendance",
                      image: MyImages.attendanceImage,
                      onClick: () {
                        scanQR();
                      }),
                  DashboardTile(
                    borderColor: MyColors.blueColor,
                    title: MyStrings.viewAttendanceText,
                    image: MyImages.viewAttendanceImage,
                    onClick: () async {
                     print(MyStrings.userInfo);
                      await getSubjects();
                     await getAttendanceInfo();

                    Navigator.of(context).pushNamed(ViewAttendance.route);
                     setState(() {

                     });
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
