class TeacherModel {
  String? uid;
  String? desc;
  String? name;
  String? phone;
  String? profilepic;
  String? email;
  String? pass;
  String? department;
  List? project_available;
  List? notifications;
  TeacherModel({this.uid,this.desc, this.name, this.profilepic, this.email, this.phone, this.pass, this.department, this.project_available, this
  .notifications});

  TeacherModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    desc = map["desc"];
    name = map["name"];
    profilepic = map["profilepic"];
    email = map["email"];
    phone = map["phone"];
    pass = map["pass"];
    department = map["department"];
    project_available = map["project_available"];
    notifications = map["notifications;"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid":uid,
      "desc": desc,
      "name": name,
      "profilepic":profilepic,
      "email": email,
      "phone": phone,
      "pass": pass,
      "department": department,
      "project_available": project_available,
      "notifications": notifications,
    };
  }
}