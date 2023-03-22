class projectModel {
  String? uid;
  String? projectname;

  List? projectdomain;
  List? projectduration;
  String? prerequisites;

  projectModel({this.uid, this.projectname, this.projectdomain, this.projectduration,this.prerequisites});

  projectModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    projectname = map["projectname"];
    projectdomain = map["projectdomain"];
    projectduration = map["projectduration"];
    prerequisites = map["prerequisites"];

  }

  Map<String, dynamic> toMap() {
    return {
      "uid":uid,
      "projectname": projectname,
      "projectdomain": projectdomain,
      "projectduration": projectduration,
      "prerequisites":prerequisites,

    };
  }
}