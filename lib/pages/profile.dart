import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/pages/roles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/FirebaseHelper.dart';
import '../models/UserModel.dart';

class profile extends StatefulWidget {
  final String role;
  const profile({super.key, required this.role});
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? pic =
      "https://www.iiitdm.ac.in/Profile/images/Profile/msm17b016.jpeg";
  late List usersData = [];
  User? currentUser = FirebaseAuth.instance.currentUser;
  /*Future getData() async {
    if (currentUser != null) {
      UserModel? thisUserModel =
          await FirebaseHelper.getUserModelById(currentUser.email.toString());

      if (thisUserModel!.profilepic != "") {
        pic = thisUserModel.profilepic;
      }
    }
    print(pic);
    print(widget.role);
    print(currentUser!.email.toString());
    DocumentSnapshot snapshot = await  FirebaseFirestore.instance
        .collection(widget.role)
        .doc(currentUser!.email.toString())
        .get();
    print(snapshot.data());
    return FirebaseFirestore.instance
        .collection("students")
        .doc("amar@gmail.com")
        .get();
  }*/
  signOut() async {
    await auth.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const Roles();
    }));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.role);
    print(currentUser!.email.toString());
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(widget.role)
          .doc(currentUser!.email.toString())
          .get()
          .asStream(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        return (!snapshot.hasData)
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).backgroundColor,
                  title:  Text(
                    'Profile',
                    style: GoogleFonts.crimsonPro(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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

                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              image: const DecorationImage(
                                  image: NetworkImage(
                                      "https://www.admissioninbangalore.in/wp-content/uploads/2021/05/bms-college-of-engineering.jpg"),
                                  fit: BoxFit.cover)),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: Container(
                              alignment: const Alignment(0.0, 2.5),
                              child: CircleAvatar(
                                backgroundImage: (snapshot.data!["profilepic"] != null)?NetworkImage(snapshot.data!["profilepic"]):const NetworkImage("https://www.iiitdm.ac.in/Profile/images/Profile/msm17b016.jpeg"),
                                radius: 60.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          snapshot.data!["name"],
                          style: GoogleFonts.varelaRound(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                     //   if (widget.role != "teachers")
                          Text(
                            snapshot.data!["desc"],
                            style: GoogleFonts.varelaRound(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                       /* Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                *//*Expanded(
                                  child: Column(
                                    children: const [
                                      Text(
                                        "Project",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "15",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ),*//*
                                *//*Expanded(
                                  child: Column(
                                    children: const [
                                      Text(
                                        "Followers",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "20",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ),*//*
                              ],
                            ),
                          ),
                        ),*/
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(
                                  Icons.email,
                                  color: Colors.red,
                                ),
                                title: const Text('Email -ID',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20)),
                                subtitle: Text(snapshot.data!["email"],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(
                                  Icons.phone_android,
                                  color: Colors.orange,
                                ),
                                title: const Text('Phone #',style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                                subtitle: (widget.role != "teachers")
                                    ? Text(snapshot.data!["phone_number"],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                                    : Text(snapshot.data!["phone"],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(
                                  Icons.school_outlined,
                                  color: Colors.green,
                                ),
                                title: const Text('Branch',style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                                subtitle: Text(snapshot.data!["department"],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        if(widget.role != "teachers")const SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (widget.role != "teachers")
                                ListTile(
                                  leading: const Icon(
                                    Icons.edit,
                                    color: Colors.purpleAccent,
                                  ),
                                  title: const Text('Skills',style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                                  subtitle: Text(
                                      snapshot.data!["project_interest"]
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(
                                  Icons.book,
                                  color: Colors.purple,
                                ),
                                title: const Text('Project Interests',style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                                subtitle: (widget.role != "teachers")
                                    ? Text(snapshot.data!["skills"].toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                                    : Text(
                                        snapshot.data!["project_available"]
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
      },
    );
  }
}
