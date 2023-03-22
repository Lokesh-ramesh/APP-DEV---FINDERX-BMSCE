class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  String? groupName;
  List<dynamic>? users;

  ChatRoomModel({this.chatroomid, this.participants, this.lastMessage, required this.users,required this.groupName});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    users = map["users"];
    groupName = map['groupName'];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "users": users,
      "groupName": groupName,
    };
  }
}