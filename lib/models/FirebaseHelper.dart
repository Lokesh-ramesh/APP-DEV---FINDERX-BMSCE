import 'package:finderr/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/models/studentModel.dart';
import 'package:finderr/models/teacherModel.dart';

class FirebaseHelper {

  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }
  static Future<StudentModel?> getStudentModelById(String uid) async {
    StudentModel? stuModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("students").doc(uid).get();

    if(docSnap.data() != null) {
      stuModel = StudentModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return stuModel;
  }
  static Future<TeacherModel?> getTeacherModelById(String uid) async {
    TeacherModel? teaModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("teachers").doc(uid).get();

    if(docSnap.data() != null) {
      teaModel = TeacherModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return teaModel;
  }
}