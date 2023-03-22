import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/pages/productlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import '../models/UserModel.dart';
class wishlist extends StatefulWidget {
  const wishlist({Key? key}) : super(key: key);

  @override
  State<wishlist> createState() => _wishlist();
}

class _wishlist extends State<wishlist> {
  UserModel? thisUserModel;

  @override
  List<String> fruits = ['ai@gmail.com', 'cse@gmail.com', 'Julian', 'Ruth', 'Vivian'];
  late List usersData = [];
  List<String> selectedFruits = ['ai@gmail.com', 'cse@gmail.com', 'Julian', 'Ruth', 'Vivian'];

  final formKey1 = GlobalKey<FormState>();
  final searchFilter = TextEditingController();
  final List<dynamic> textFieldsValue = [];


  void _showMultiSelect(BuildContext context) async
  {

    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            icon: Center(
              child: Column(
                children: [
                  DropDownMultiSelect(
                    options: fruits,
                    selectedValues: selectedFruits,
                    onChanged: (value) async {
                      print('selected fruit $value');
                      //enabled: false;
                      setState(() {
                        selectedFruits = value;
                      },
                      );
                      // FirebaseFirestore.instance.collection('filter').
                      // doc('Attractions').set(
                      //     {"field": FieldValue.arrayUnion(selectedFruits)});
                      print('you have selected $selectedFruits fruits.');
                      if(selectedFruits.isEmpty){
                        selectedFruits = ['ai@gmail.com', 'cse@gmail.com', 'Julian', 'Ruth', 'Vivian'];
                      }
                    },
                    whenEmpty: 'Select your choice',
                  ),
                ],
              ),
            ),
          );
        },
    );
  }



  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    // UserModel? thisUserModel;
    // String? email = thisUserModel?.email;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black, // <-- SEE HERE
          ),
          title: const Text(
            'Wishlist',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()));
                  _showMultiSelect(context);
                  },
                icon: const Icon(Icons.tune,color: Colors.black,))
          ],
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.75)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(Icons.search),
                    ),
                    SizedBox(width: 70,),
                    Flexible(
                      child: TextFormField(
                        controller: searchFilter,
                        decoration: const InputDecoration(
                          hintText: 'Search by name',
                          border: InputBorder.none,
                        ),
                        onChanged: (String value) {
                          setState(() {});
                        },
                        maxLines: 1,
                        minLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(

              child: StreamBuilder<QuerySnapshot>(


                stream: FirebaseFirestore.instance
                    .collection("wishlist").where("user_email",isEqualTo: user?.email)
                    .snapshots(),

              // stream: FirebaseFirestore.instance.collection("wishlist").where("projects",arrayContainsAny:selectedFruits).snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data = snapshot.data!.docs[index];
                            final name = data['name'];
                            if (searchFilter.text.isEmpty) {
                              return ProductItem(
                                documentSnapshot: data,
                                email: data['email'],
                                //location: data['location'],
                                name: data['name'],
                                projects: data['projects'],
                                profilepic:data['profilepic'],
                                docid: snapshot.data!.docs[index].id.toString(),
                                // index:index.toString(),
                              );
                            } else if (name.toLowerCase().contains(searchFilter
                                .text
                                .toLowerCase()
                                .toLowerCase())) {
                              return ProductItem(
                                documentSnapshot: data,
                                email: data['email'],
                                //location: data['location'],
                                name: data['name'],
                                projects: data['projects'],
                                profilepic:data['profilepic'],

                                docid: snapshot.data!.docs[index].id.toString(),
                              );
                            } else {
                              return Container();
                            }
                            print(snapshot.data!.docs[index]);
                          },
                        );
                },
              ),
            )
          ],
        ));
  }
}

// Widget _buildRow(String imageAsset, String name, double score) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//     child: Column(
//       children: <Widget>[
//         const SizedBox(height: 12),
//         Container(height: 2, color: Colors.redAccent),
//         const SizedBox(height: 12),
//         Row(
//           children: <Widget>[
//             CircleAvatar(backgroundImage: AssetImage(imageAsset)),
//             const SizedBox(width: 12),
//             Text(name),
//             const Spacer(),
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.yellow[900],
//                   borderRadius: BorderRadius.circular(20)),
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//               child: Text('$score'),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }




