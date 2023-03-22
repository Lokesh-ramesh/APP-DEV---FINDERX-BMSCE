
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/models/studentModel.dart';
import 'package:finderr/pages/chatroom.dart';
import 'package:finderr/pages/group_chat.dart';
import 'package:finderr/pages/select_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/ChatRoomModel.dart';
import '../models/FirebaseHelper.dart';
import '../models/UserModel.dart';
import '../models/teacherModel.dart';

class direct extends StatefulWidget {
  final UserModel? userModel;

  const direct({Key? key, required this.userModel}) : super(key: key);

  @override
  _directState createState() => _directState();
}

class _directState extends State<direct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context)  =>  members(),));
          }, icon: const Icon(Icons.groups,color: Colors.black,))
        ],
        title: const Text("Messages",style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("users", arrayContains: widget.userModel!.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot =
                      snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;
                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModel!.email);

                      return FutureBuilder(
                        future:
                            FirebaseHelper.getUserModelById(participantKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;
                              /* print(targetUser.email);
                              print(widget.userModel!.email);*/
                              return participantKeys.length!=2?Container(
                                decoration: BoxDecoration(
                                  border:Border(
                                    left: BorderSide(width: 1.0, color: Colors.black.withOpacity(0.1)),
                                    right: BorderSide(width: 1.0, color: Colors.black.withOpacity(0.1)),
                                    bottom: BorderSide(width: 1.0, color: Colors.black.withOpacity(0.1)),
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    String? role;
                                    var tea = await FirebaseFirestore.instance
                                        .collection("teachers")
                                        .doc(targetUser.email)
                                        .get();
                                    var stu = await FirebaseFirestore.instance
                                        .collection("students")
                                        .doc(targetUser.email)
                                        .get();
                                    if (tea.exists) {
                                      role = "teachers";
                                    } else if (stu.exists) {
                                      role = "students";
                                    }
                                    if (role == "teachers") {
                                      TeacherModel? target = await FirebaseHelper
                                          .getTeacherModelById(
                                              targetUser.email.toString());
                                      StudentModel? user = await FirebaseHelper
                                          .getStudentModelById(
                                              widget.userModel!.email.toString());
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return Chatroom(
                                            targetUser: target,
                                            chatroom: chatRoomModel,
                                            userModel: user,
                                          );
                                        }),
                                      );
                                    } else {
                                      StudentModel? target = await FirebaseHelper
                                          .getStudentModelById(
                                              targetUser.email.toString());
                                      TeacherModel? user = await FirebaseHelper
                                          .getTeacherModelById(
                                              widget.userModel!.email.toString());
                                      print(user);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return Chatroom(
                                            targetUser: target,
                                            chatroom: chatRoomModel,
                                            userModel: user,
                                          );
                                        }),
                                      );
                                    }
                                  },
                                  leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          targetUser.profilepic.toString())),
                                  title: Text(targetUser.fullname.toString()),
                                  subtitle: (chatRoomModel.lastMessage
                                              .toString() !=
                                          "")
                                      ? Text(chatRoomModel.lastMessage.toString())
                                      : Text(
                                          "Say hi to your new friend!",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                ),
                              ):
                              Container(
                                decoration: BoxDecoration(
                                  border:Border(
                                    left: BorderSide(width: 1.0, color: Colors.black.withOpacity(0.1)),
                                    right: BorderSide(width: 1.0, color: Colors.black.withOpacity(0.1)),
                                    bottom: BorderSide(width: 1.0, color: Colors.black.withOpacity(0.1)),
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return GroupChatroom(
                                          group_users: participants.keys.toList(),
                                          chatroom: chatRoomModel,
                                          admin: FirebaseAuth.instance.currentUser!.email,
                                        );
                                      }),
                                    );
                                  },
                                  leading: Icon(Icons.person),
                                  title: Text(chatRoomModel.groupName.toString()),
                                  subtitle: (chatRoomModel.lastMessage
                                      .toString() !=
                                      "")
                                      ? Text(chatRoomModel.lastMessage.toString())
                                      : Text(
                                    "Say hi to your new friend!",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("No Chats"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
