

class studModel {
  String? uid;

  studModel({this.uid});

  studModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
    };
  }
}