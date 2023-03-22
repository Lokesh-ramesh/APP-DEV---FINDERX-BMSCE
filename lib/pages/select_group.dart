import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/pages/group_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/ChatRoomModel.dart';
import 'chatroom.dart';

class members extends StatefulWidget {
  const members({Key? key}) : super(key: key);

  @override
  State<members> createState() => _membersState();
}

class _membersState extends State<members> {
  final TextEditingController _search = TextEditingController();
  final TextEditingController _gname = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  List<Map<String, dynamic>> admin = [];
 Map<String,dynamic> gusers= {};
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.email)
        .get()
        .then((map) {
      setState(() {
        print(map);
        membersList.add({
          "name": map['fullname'],
          "email": map['email'],
          "uid": map['uid'],
          "pic":map['profilepic'],
          "isAdmin": true,
        });

      });
    });
  }

  void onSearch() async {

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": userMap!['fullname'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "pic":userMap!['profilepic'],
          "isAdmin": false,
        });

        userMap = null;
      });
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }
  Future<ChatRoomModel?> getChatroomModel(List group_members,String groupname) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection("chatrooms").get();
    bool exist = false;
    var flag = 0;
    var doc;
    if (snapshot.docs.length > 0) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        doc = snapshot.docs[i].data();
        ChatRoomModel? existingChatroom =
        ChatRoomModel.fromMap(doc as Map<String, dynamic>);
        for(var i=0;i<group_members.length;i++)
          {
            if (existingChatroom.users![i] == group_members[i]) {
              flag = flag + 1;
            }
            else
              {
               break;
              }
          }
        if(flag == group_members.length)
          {
            exist = true;
          }
      }
    }

    if (exist) {
      log("exits");
      // Fetch the existing one
      //var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
      ChatRoomModel.fromMap(doc as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one

      for(var i = 0;i<group_members.length;i++)
        {
          gusers[group_members[i].toString()]="true";
        }
      print(gusers);
      ChatRoomModel newChatroom =
      ChatRoomModel(chatroomid: uuid.v1(), lastMessage: "",participants:gusers,users: group_members,groupName: groupname);

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }

    return chatRoom;
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _gname,
                  decoration: InputDecoration(
                    hintText: "Enter Group Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height/20,),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
              height: size.height / 12,
              width: size.height / 12,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).backgroundColor
              ),
              onPressed: onSearch,
              child: Text("Search"),
            ),
            userMap != null
                ? ListTile(
              onTap: onResultTap,
              leading: CircleAvatar(
                radius: 35,
                child: ClipOval(
                    child: Image(image: NetworkImage(userMap!['profilepic']))),
              ),
              title: Text(userMap!['fullname']),
              subtitle: Text(userMap!['email']),
              trailing: Icon(Icons.add),
            )
                : SizedBox(),
          Flexible(
            child: ListView.builder(
              itemCount: membersList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => onRemoveMembers(index),
                  leading: CircleAvatar(
                    radius: 35,
                    child: ClipOval(
                        child: Image(image: NetworkImage(membersList[index]["pic"]!))),
                  ),
                  /*membersList[index]['fullname']!=Null?membersList[index]['fullname']!:""*/
                  title: Text(membersList[index]["name"]!),
                  subtitle: Text(membersList[index]["email"]),
                  trailing: membersList[index]['uid'] != _auth.currentUser!.uid?Icon(Icons.close):Icon(Icons.admin_panel_settings),
                );
              },
            ),
          )
          ],

        ),
      ),
      floatingActionButton: membersList.length >= 3
          ? FloatingActionButton(
        child: Icon(Icons.forward),
        onPressed: () async {
          List group_users = [];
          for(var i = 0;i<membersList.length;i++)
            {
             group_users.add(membersList[i]["email"]);
            }
          print(group_users);
          print(_gname.text);
          ChatRoomModel? chatroomModel =
              await getChatroomModel(group_users,_gname.text);
          if (chatroomModel != null) {
          Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return GroupChatroom(
                    admin: _auth.currentUser?.email,
                    group_users: group_users,
                    group_name: _gname.text,
                    chatroom: chatroomModel,
                  );
                }));
          };
        }
      )
          : SizedBox(),
    );
  }
}