import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/models/FirebaseHelper.dart';
import 'package:finderr/models/UserModel.dart';
import 'package:finderr/pages/direct.dart';
import 'package:finderr/pages/navbar.dart';
import 'package:finderr/pages/scroll_list.dart';
import 'package:finderr/pages/scroll_list_students.dart';
import 'package:finderr/pages/temp/new_project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';

class Scroll extends StatelessWidget {
  final role;
  Scroll({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return (role == "students") ? const Students() : const Teachers();
  }
}

class Teachers extends StatefulWidget {
  const Teachers({Key? key}) : super(key: key);

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> fruits = ['IMAGE PROCESSING', 'WEB DEV', 'APP DEV', 'AI/ML'];
  List<String> selectedFruits = [];
  final searchFilter = TextEditingController();
  final List<dynamic> textFieldsValue = [];
  void _showMultiSelect(BuildContext context) async {
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
                      setState(
                            () {
                          selectedFruits = value;
                          //initState();
                        },
                      );
                      // FirebaseFirestore.instance.collection('filter').
                      // doc('Attractions').set(
                      //     {"field": FieldValue.arrayUnion(selectedFruits)});
                      print('you have selected $selectedFruits.');
                      if (selectedFruits.isEmpty) {
                        selectedFruits = [
                          'IMAGE PROCESSING',
                          'WEB DEV',
                          'APP DEV'
                        ];
                      }
                    },
                    whenEmpty: 'Select your choice ',
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Dummy Product Data Here
  final List myProducts = List.generate(100, (index) {
    return {"id": index, "title": "Product #$index", "price": index + 1};
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(user: currentUser!.email.toString(),),
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 3),
                child: IconButton(
                    onPressed: () async {
                      User? currentUser = FirebaseAuth.instance.currentUser;
                      UserModel? userModel = await FirebaseHelper.getUserModelById(currentUser!.email.toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)  =>  direct(userModel: userModel),));
                    },
                    icon: const Icon(Icons.chat))),
            IconButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()));
                  _showMultiSelect(context);
                },
                icon: const Icon(Icons.tune))
          ],
          title: Text(
            "Finder",
            style: GoogleFonts.crimsonPro(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 60,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
          iconTheme: const IconThemeData(color: Colors.black),
        ),

        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(

            children:[
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
                            hintText: 'Search by email',
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
                  /*stream: FirebaseFirestore.instance
                      .collection("wishlist")
                      .snapshots(),*/
                  stream: (selectedFruits.isEmpty)
                      ? FirebaseFirestore.instance.collection("teachers").snapshots()
                      : FirebaseFirestore.instance
                      .collection("teachers")
                      .where("project_available", arrayContainsAny: selectedFruits)
                      .snapshots(),
                  // stream: FirebaseFirestore.instance.collection("wishlist").where("projects",arrayContainsAny:selectedFruits).snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        final email = data['email'];
                        if (searchFilter.text.isEmpty) {
                          return scroll_list(
                            documentSnapshot: data,
                            email: data['email'],
                            name: data['name'],
                            //location: data['location'],
                            department: data['department'],
                            project_available: data['project_available'],
                            profilepic:data['profilepic'],
                            docid: snapshot.data!.docs[index].id.toString(),
                            index: index.toString(),
                          );
                        }
                        else if (email.toLowerCase().contains(searchFilter
                            .text
                            .toLowerCase()
                            .toLowerCase())) {
                          return scroll_list(
                            documentSnapshot: data,
                            email: data['email'],
                            name: data['name'],
                            //location: data['location'],
                            department: data['department'],
                            project_available: data['project_available'],
                            profilepic:data['profilepic'],
                            docid: snapshot.data!.docs[index].id.toString(),
                            index: index.toString(),
                          );
                        } else {
                          return Container();
                        }
                        print(snapshot.data!.docs[index]);
                      },
                    );
                  },
                ),
              ),]
        ));
  }
}

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  List<String> fruits = ['PYTHON', 'WEB DEV', 'IMAGE PROCESSING', 'AI/ML'];
  List<String> selectedFruits = [];
  final searchFilter = TextEditingController();
  final List<dynamic> textFieldsValue = [];
  void _showMultiSelect(BuildContext context) async {
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
                      setState(
                            () {
                          selectedFruits = value;
                          //initState();
                        },
                      );
                      // FirebaseFirestore.instance.collection('filter').
                      // doc('Attractions').set(
                      //     {"field": FieldValue.arrayUnion(selectedFruits)});
                      print('you have selected $selectedFruits.');
                      if (selectedFruits.isEmpty) {
                        selectedFruits = [
                          'IMAGE PROCESSING',
                          'WEB DEV',
                          'APP DEV'
                        ];
                      }
                    },
                    whenEmpty: 'Select your choice',
                  ),
                ],
              ),
            ),
          );
        });
  }
  bool isLoading = true;
  late List usersData = [];
  late List skills = [];
  User? currentUser = FirebaseAuth.instance.currentUser;
  late final CollectionReference _collectionRef;
  // Dummy Product Data Here
  final List myProducts = List.generate(100, (index) {
    return {"id": index, "title": "Product #$index", "price": index + 1};
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(user: currentUser!.email.toString(),),
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 3),
              child: IconButton(
                  onPressed: () async{
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    UserModel? userModel = await FirebaseHelper.getUserModelById(currentUser!.email.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  direct(userModel: userModel,)));
                  },
                  icon: const Icon(Icons.chat))),
          IconButton(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()));
                _showMultiSelect(context);
              },
              icon: const Icon(Icons.tune))
        ],
        title: Text(
          "Finder",
          style: GoogleFonts.crimsonPro(
            textStyle:  TextStyle(
              color: Colors.black,
              fontSize: 50,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(

          children:[
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
                          hintText: 'Search by email',
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
              child: Stack(
                  children:[StreamBuilder<QuerySnapshot>(
                    /*stream: FirebaseFirestore.instance
                      .collection("wishlist")
                      .snapshots(),*/
                    stream: (selectedFruits.isEmpty)
                        ? FirebaseFirestore.instance.collection("students").snapshots()
                        : FirebaseFirestore.instance
                        .collection("students")
                        .where("project_interest", arrayContainsAny: selectedFruits)
                        .snapshots(),
                    // stream: FirebaseFirestore.instance.collection("wishlist").where("projects",arrayContainsAny:selectedFruits).snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          final email = data['email'];
                          if (searchFilter.text.isEmpty) {
                            return scroll_list_students(
                              documentSnapshot: data,
                              email: data['email'],
                              name: data['name'],
                              department: data['department'],
                              desc:data['desc'],

                              project_interest: data['project_interest'],
                              profilepic:data['profilepic'],
                              docid: snapshot.data!.docs[index].id.toString(),
                              index: index.toString(),
                            );
                          }
                          else if (email.toLowerCase().contains(searchFilter
                              .text
                              .toLowerCase()
                              .toLowerCase())) {
                            return scroll_list_students(
                              documentSnapshot: data,
                              email: data['email'],
                              name: data['name'],
                              department: data['department'],
                              desc:data['desc'],
                              project_interest: data['project_interest'],
                              profilepic:data['profilepic'],
                              docid: snapshot.data!.docs[index].id.toString(),
                              index: index.toString(),
                            );
                          } else {
                            return Container();
                          }
                          print(snapshot.data!.docs[index]);
                        },
                      );
                    },
                  ),
                    Align(alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          child: new Icon(Icons.add),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => projectdetails()));
                          }),),]
              ),


            ),]
      ),
    );
  }
}
