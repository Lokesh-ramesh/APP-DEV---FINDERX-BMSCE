class MessageModel {
  String? messageid;
  String? sender_name;
  String? sender_email;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel({this.messageid, this.sender_name, this.text, this.seen, this.createdon,this.sender_email});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender_name = map["sender_name"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
    sender_email = map['sender_email'];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender_name": sender_name,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "sender_email": sender_email
    };
  }
}