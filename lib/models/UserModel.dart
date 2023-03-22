class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? pass;
  String? profilepic;

  UserModel({this.uid, this.fullname, this.email, this.pass, this.profilepic});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    pass = map["pass"];
    profilepic = map["profilepic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "pass": pass,
      "profilepic": profilepic,
    };
  }
}