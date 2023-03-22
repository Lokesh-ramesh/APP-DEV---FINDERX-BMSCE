import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firestoredatabase/operations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';


class ProductItem extends StatefulWidget {
 final String name;
  final String email;
 final String profilepic;
  final List projects;
  final DocumentSnapshot documentSnapshot;


   final String docid;
  // final String index;
  ProductItem({

    required this.documentSnapshot,
    required this.email,
    required this.name,
    required this.projects,
    required this.profilepic,
     required this.docid,
    // required this.index,
  });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    // child: Scaffold(
    //
    //     backgroundColor: Colors.lightBlue[100],
       return Column(
          children: [
            const SizedBox(height: 0),
            GestureDetector(
              onDoubleTap: () async {
                final collection =
                FirebaseFirestore.instance.collection('wishlist');

                collection
                    .doc(widget.docid) // <-- Doc ID to be deleted.
                    .delete() // <-- Delete
                    .then((_) => print('Deleted'))
                    .catchError(
                        (error) => print('Delete failed: $error'));
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                height: 90,
                //  color: Colors.white,
                decoration:  BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [Colors.lightBlueAccent, Colors.white],
                  //   begin: Alignment.bottomLeft,
                  //   end: Alignment.topRight,
                  // ),

                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30.0),

                  ),
                  border: Border.all(color: Colors.grey),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 0.7,
                        offset: Offset(0.5, 0.5)
                    ),
                  ],
                ),

                //child: SizedBox(height: 50),
                child: Row(
                  children:[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.network(widget.profilepic,
                          width: 75,
                          height: 75,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          const SizedBox(height: 20),
                          Text(widget.name,
                            style: GoogleFonts.varelaRound(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(widget.projects.toString(),  style: GoogleFonts.crimsonPro(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),)
                        ]
                    ),
                  ],
                ),
              ),
            ),


          ],
        );
     // ),
    //);

  }
}