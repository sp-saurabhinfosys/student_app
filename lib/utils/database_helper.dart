import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static String collectionCollege = "college";
  static String keyCollegeCode = "collegeCode";
  static String keyCollegeName = "collegeName";
  static String keyCollegeLocation = "collegeLocation";
  static String keyStudentName = "studentName";
  static String keyStudentEnrollment = "studentEnrollment";
  static String keyStudentPhoneNo = "studentPhoneNo";
  static String keyFacultyName = "facultyName";
  static String keyFacultyId = "facultyId";
  static String keyFacultyPhoneNo = "facultyPhoneNumber";
  static String keyPresent = "present";
  static String keyTimetable = "timetable";


//add department
//add semester
//class timetable
//take attendance
  signUpMethod({String collegeId, String departmentName, Map<String, dynamic> map,String phoneNo}){

    FirebaseFirestore.instance.collection("college").doc(collegeId).collection(departmentName).doc(departmentName.replaceAll(" ", "")).collection("Teachers").doc(phoneNo).set(map);
    FirebaseFirestore.instance.collection("Teachers").doc(phoneNo).set(map);
    print("Done");

  }

  addClass({String collegeId, String departmentName, Map<String, dynamic> map,String className}){

    FirebaseFirestore.instance.collection("college").doc(collegeId).collection(departmentName).doc(departmentName.replaceAll(" ", "")).collection("Classes").doc(className.replaceAll(" ", "")).set(map);
    FirebaseFirestore.instance.collection("Classes").doc(className.replaceAll(" ", "")).set(map);
    print("Done");

  }

  addSubject({String collegeId, String departmentName, Map<String, dynamic> map,String subjectName,String className}){

    FirebaseFirestore.instance.collection("college").doc(collegeId).collection(departmentName).doc(departmentName.replaceAll(" ", "")).collection("Classes").doc(className.replaceAll(" ", "")).collection("Subjects").doc(subjectName.replaceAll(" ", "")).set(map);
    FirebaseFirestore.instance.collection("Subjects").doc(subjectName.replaceAll(" ", "")).set(map);
    print("Done");

  }
  addStudent({String collegeId, String departmentName, Map<String, dynamic> map,String enrollment,String className}){
    FirebaseFirestore.instance.collection("Students").doc(enrollment.replaceAll(" ", "")).set(map);
    FirebaseFirestore.instance.collection("college").doc(collegeId).collection(departmentName).doc(departmentName.replaceAll(" ", "")).collection("Classes").doc(className.replaceAll(" ", "")).collection("Students").doc(enrollment).set(map);
    print("Done");

  }
  giveAttendance({String dept,String cid,String myClass,String subject,String date,String enrollment})
  async {
    await FirebaseFirestore.instance
        .collection("college")
        .doc(cid)
        .collection(dept)
        .doc(dept.replaceAll(" ", ""))
        .collection("Classes")
        .doc(myClass.replaceAll(" ", ""))
        .collection("Subjects")
        .doc(subject.replaceAll(" ", ""))
        .collection("attendance")
        .doc("$date")
        .collection("student")
        .doc(enrollment)
        .update({'present':true});

    await FirebaseFirestore.instance
        .collection("college")
        .doc(cid)
        .collection(dept)
        .doc(dept.replaceAll(" ", ""))
        .collection("Classes")
        .doc(myClass.replaceAll(" ", ""))
        .collection("Students")
        .doc(enrollment.replaceAll(" ", ""))
        .collection(subject)
        .doc("$date")
        .update( {

      "present": true,
    },);


  }


}
