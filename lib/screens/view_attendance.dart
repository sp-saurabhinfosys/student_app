import 'package:flutter/material.dart';
import 'package:student_app/utils/utils.dart';

class ViewAttendance extends StatefulWidget {
  static String route = "ViewAttendance";

  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

    });
    print(MyStrings.stData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance"),),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                child: ListView.builder(
                    itemCount: MyStrings.subjectList.length,
                    itemBuilder: (c, i) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              MyStrings.subjectList[i],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${MyStrings.stData[i][MyStrings.subjectList[i]][0].toString()}/${MyStrings.stData[i][MyStrings.subjectList[i]][1].toString()}",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      );
                    })),
          ]),
        ),
      ),
    );
  }
}
