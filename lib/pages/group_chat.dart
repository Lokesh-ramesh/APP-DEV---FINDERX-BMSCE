import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/models/ChatRoomModel.dart';
import 'package:finderr/models/FirebaseHelper.dart';
import 'package:finderr/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/MessageModel.dart';

class GroupChatroom extends StatefulWidget {
  final  group_users;
  final group_name;
  final admin;
  final ChatRoomModel chatroom;
  const GroupChatroom({super.key, required this.group_users, required this.admin, required this.chatroom, this.group_name,});
  @override
  State<GroupChatroom> createState() => _GroupChatroomState();
}

class _GroupChatroomState extends State<GroupChatroom> {

  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    UserModel? userModel= await FirebaseHelper.getUserModelById(widget.admin);
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender_email: userModel!.email!,
          sender_name: userModel!.fullname,
          createdon: DateTime.now(),
          text: msg,
          seen: false
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());

      log("Message Sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [

            /*CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(widget.targetUser.profilepic.toString()),
            ),
*/
            const SizedBox(width: 10,),
            Text(widget.chatroom.groupName.toString()),

          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [

              // This is where the chats will go
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.active) {
                        if(snapshot.hasData) {
                          QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                              return Row(
                                mainAxisAlignment: (currentMessage.sender_email == widget.admin) ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                           left: 5,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (currentMessage.sender_email == widget.admin) ? Colors.grey : Theme.of(context).colorScheme.secondary,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Text(currentMessage.sender_name.toString(),style: TextStyle(color: Colors.white,fontSize: 10),),
                                              SizedBox(height: 10,),
                                              Text(
                                                currentMessage.text.toString()!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else if(snapshot.hasError) {
                          return const Center(
                            child: Text("An error occured! Please check your internet connection."),
                          );
                        }
                        else {
                          return const Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      }
                      else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),

              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5
                ),
                child: Row(
                  children: [

                    Flexible(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter message"
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary,),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
