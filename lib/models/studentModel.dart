class StudentModel {
  String? uid;
  String? desc;
  String? name;
  String? email;
  String? pass;
  String? department;
  String? profilepic;
  List? skills;
  List? project_interest;
  String? phone_number;
  List? notifications;
  StudentModel({this.uid, this.desc, this.name, this.pass, this.email, this.department,this.profilepic, this.skills,this.project_interest,this.phone_number,this.notifications});

  StudentModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    desc = map["desc"];
    name = map["name"];
    email = map["email"];
    pass = map["pass"];
    department = map["department"];
    profilepic = map["profilepic"];
    skills = map["skills"];
    project_interest = map["project_interest"];
    phone_number = map["phone_number"];
    notifications = map["notifications"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid":uid,
      "desc": desc,
      "name": name,
      "email": email,
      "pass":pass,
      "department": department,
      "profilepic":profilepic,
      "skills":skills,
      "project_interest":project_interest,
      "phone_number":phone_number,
      "notifications":notifications,
    };
  }
}