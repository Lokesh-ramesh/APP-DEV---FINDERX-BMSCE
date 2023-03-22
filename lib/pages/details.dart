import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/models/studentModel.dart';
import 'package:finderr/models/teacherModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../models/ChatRoomModel.dart';
import '../models/FirebaseHelper.dart';
import '../models/UserModel.dart';
import 'chatroom.dart';

class Details extends StatefulWidget {
  final String doc_id;
  final String role;
  const Details({super.key, required this.doc_id, required this.role});
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? email;
  TeacherModel? userModel;
  StudentModel? targetUser;
  String? pic =
      "https://www.iiitdm.ac.in/Profile/images/Profile/msm17b016.jpeg";
  late List usersData = [];
  Future getData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      email = currentUser.email;
      UserModel? thisUserModel =
          await FirebaseHelper.getUserModelById(widget.doc_id);

      if (thisUserModel!.profilepic != "") {
        pic = thisUserModel.profilepic;
      }
    }
    targetUser = await FirebaseHelper.getStudentModelById(widget.doc_id);
    userModel = await FirebaseHelper.getTeacherModelById(email!);
    //print(widget.doc_id);
    return FirebaseFirestore.instance
        .collection(widget.role)
        .doc(widget.doc_id)
        .get();
  }

  Future<ChatRoomModel?> getChatroomModel(StudentModel targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("chatrooms").get();
    bool exist = false;
    var doc;
    if (snapshot.docs.length > 0) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        doc = snapshot.docs[i].data();
        ChatRoomModel existingChatroom =
            ChatRoomModel.fromMap(doc as Map<String, dynamic>);
        if (existingChatroom.participants!.containsKey(targetUser.email) &&
            existingChatroom.participants!.containsKey(userModel!.email) && existingChatroom.participants!.length==2) {
          exist = true;
          break;
        }
      }
    }

    if (exist) {
      // Fetch the existing one
      //var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(doc as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom =
          ChatRoomModel(chatroomid: uuid.v1(),groupName: "", lastMessage: "", participants: {
        userModel!.email.toString(): true,
        targetUser.email.toString(): true,
      }, users: [
        userModel!.email.toString(),
        targetUser.email.toString()
      ]);

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
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title: Text(
              snapshot.data["name"]!,
              style: const TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              image: NetworkImage(pic.toString()),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          snapshot.data["name"]!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                User? currentUser =
                                    FirebaseAuth.instance.currentUser;
                                String? email;
                                if (currentUser != null) {
                                  email = currentUser.email;
                                }
                                await FirebaseFirestore.instance
                                    .collection("students")
                                    .doc(snapshot.data["email"])
                                    .set({
                                  "notifications":
                                      FieldValue.arrayUnion([email])
                                }, SetOptions(merge: true)).then((value) {
                                  print("added");
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Connect",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontSize: 22.0),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.person_add,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                ChatRoomModel? chatroomModel =
                                    await getChatroomModel(targetUser!);
                                if (chatroomModel != null) {
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Chatroom(
                                      targetUser: targetUser,
                                      userModel: userModel,
                                      chatroom: chatroomModel,
                                    );
                                  }));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Message",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontSize: 22.0),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(
                                      Icons.message_outlined,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Padding(
                        padding: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            'Details',
                            style: GoogleFonts.crimsonPro(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.email),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              snapshot.data["email"]!,
                              style: GoogleFonts.varelaRound(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.school),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              snapshot.data["department"]!,
                              style: GoogleFonts.varelaRound(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.bookmarks_sharp),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                snapshot.data["desc"]!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: GoogleFonts.varelaRound(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Padding(
                        padding: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            'Skills',
                            style: GoogleFonts.crimsonPro
                              (
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 27,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        child: Wrap(
                          spacing: snapshot.data["skills"]!.length + 0.0,
                          children: [
                            ...List.generate(
                              snapshot.data["skills"]!.length,
                              (index) => Chip(
                                backgroundColor:
                                  Theme.of(context).backgroundColor,
                                label: Text(
                                  snapshot.data["skills"]![index],
                                  style: GoogleFonts.varelaRound(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                 Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, top: 5, bottom: 5, right: 5),
                                  child: Text(
                                    'Projects Completed',
                                    style: GoogleFonts.varelaRound(
                                  textStyle: const TextStyle(
                                  color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                      ),
                                  ),
                                ),
                                Row(
                                  children:  [
                                    Icon(Icons.star),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '10',
                                        style: GoogleFonts.varelaRound(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const VerticalDivider(
                              width: 2,
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                            Column(
                              children: [
                                 Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'Projects Ongoing',
                                    style: GoogleFonts.varelaRound(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children:  [
                                    Icon(Icons.star_half),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '10',
                                        style: GoogleFonts.varelaRound(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                       Padding(
                        padding: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            'Interests',
                            style: GoogleFonts.crimsonPro
                              (
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 27,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        child: Wrap(
                          spacing: snapshot.data["skills"]!.length + 0.0,
                          children: [
                            ...List.generate(
                              snapshot.data["skills"]!.length,
                              (index) => Chip(
                                backgroundColor:
                                Theme.of(context).backgroundColor,
                                label: Text(
                                  snapshot.data["skills"][index],
                                  style: GoogleFonts.varelaRound(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
