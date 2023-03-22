import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/UserModel.dart';
import 'detail_teacher.dart';

class scroll_list extends StatefulWidget {
  final String profilepic;
  final String name;
  final String email;
  final String department;
  final List project_available;
  final DocumentSnapshot documentSnapshot;

  final String docid;
  final String index;
  scroll_list({
    required this.documentSnapshot,
    required this.email,
    required this.name,
    required this.department,
    required this.project_available,
    required this.profilepic,
    required this.docid,
    required this.index,
  });

  @override
  _scroll_list createState() => _scroll_list();
}

class _scroll_list extends State<scroll_list> {
  User? user = FirebaseAuth.instance.currentUser;

  late List skills = [];
  final List myProducts = List.generate(100, (index) {
    return {"id": index, "title": "Product #$index", "price": index + 1};
  });
  @override
  Widget build(BuildContext context) {
    skills = widget.project_available;
    print(widget.project_available);
    return Dismissible(
      key: UniqueKey(),

      // only allows the user swipe from right to left
      direction: DismissDirection.startToEnd,

      // Remove this product from the list
      // In production enviroment, you may want to send some request to delete it on server side
      onDismissed: (_) async {
        // UserModel? thisUserModel;
        // String? email = thisUserModel?.email;
        final collection = FirebaseFirestore.instance.collection('wishlist');
        await collection.doc().set(
          {
           "user_email":user?.email,
            "email": widget.email,
            "name": widget.name,
            "projects": widget.project_available,
            "profilepic": widget.profilepic,
          },
        ).then((value) => {print("teacher addded")});
      },
      // This will show up when the user performs dismissal action
      // It is a red background and a trash icon
      background: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.bookmark,
          color: Theme.of(context).primaryColor.withOpacity(0.75),
        ),
      ),

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 35,
                  child: ClipOval(
                      child: Image(image: NetworkImage(widget.profilepic))),
                ),
                title: Text(widget.email,
                  style: GoogleFonts.varelaRound(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                subtitle: Text(widget.department,
                  style: GoogleFonts.crimsonPro(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                width: double.infinity,
                child: Wrap(
                  spacing: skills.length + 0.0,
                  children: [
                    ...List.generate(
                      skills.length,
                      (index) => Chip(
                        label: Text(
                          skills[index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.all(8),
                        backgroundColor:
                        Theme.of(context).backgroundColor,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.75),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark_outline,
                        size: 30,
                      ),
                      onPressed: () async {
                        final collection =
                            FirebaseFirestore.instance.collection('wishlist');
                        await collection.doc().set(
                          {
                            "user_email":user?.email,
                            "email": widget.email,
                            "name": widget.email,
                            "projects": widget.project_available,
                            "profilepic": widget.profilepic,
                          },
                        );
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Details_teach(
                                      role: "teachers", doc_id: widget.email)));
                        },
                        icon: (Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.black,
                          size: 30,
                        ))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
