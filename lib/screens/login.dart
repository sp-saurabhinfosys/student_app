import 'package:flutter/material.dart';
import 'package:student_app/custom_widgets/buttons.dart';
import 'package:student_app/custom_widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_app/screens/admin_dashboard.dart';
import 'package:student_app/utils/utils.dart';

class Login extends StatefulWidget {
  static String route = "Login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  QuerySnapshot d;
  searchUser()
  async {

    d = await FirebaseFirestore.instance.collection("Students").where("pass",isEqualTo: passController.text).where("enrollment",isEqualTo: phoneController.text).get();
    print("Id ${d.docs.length}");
    MyStrings.userInfo = {
      "className":d.docs[0]['className'],
      "collegeId":d.docs[0]['collegeId'],
      "departmentName":d.docs[0]['departmentName'],
      "enrollment":d.docs[0]['enrollment'],
      "name":d.docs[0]['name'],
      "pass":d.docs[0]['pass'],
      "phone":d.docs[0]['phone'],
    };
    print(MyStrings.userInfo);
    if(MyStrings.userInfo==null)
      {
        print("invalid id pass");
      }
    else if(MyStrings.userInfo!=null)
      {
        Navigator.of(context).pushNamed(Dashboard.route);
      }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EnrollmentNoTextField(controller: phoneController),
            PasswordTextField(controller: passController),
            SignInButton(onClick: (){
              searchUser();
            },),
          ],
        ),
      ),
    );
  }
}
