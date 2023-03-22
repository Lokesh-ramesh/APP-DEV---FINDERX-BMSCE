import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/models/get_students.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import '../../models/FirebaseHelper.dart';
import '../../models/UserModel.dart';
//import 'detail.dart';

class Choice extends StatelessWidget {
  final role;

  const Choice({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return (role == "student") ? const Teachers() : const Students();
  }
}

class Teachers extends StatefulWidget {
  const Teachers({Key? key}) : super(key: key);

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  var details = {};
  var det = {};
  bool liked = false;
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('teachers');
  bool isLoading = true;
  late List usersData = [];

  //push email of student who right swiped teacher
  void right(String tid) async {
    print(tid);
    User? currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser!.uid);
    if (currentUser != null) {
      UserModel? thisUserModel =
          await FirebaseHelper.getUserModelById(currentUser.uid);
      print(thisUserModel!.email);
      studModel suid = studModel(uid: thisUserModel.email);
      await FirebaseFirestore.instance
          .collection("teachers")
          .doc(tid)
          .collection("right_swipe")
          .doc("right_swipe")
          .set({
        "uid": FieldValue.arrayUnion([suid.toMap()])
      }, SetOptions(merge: true)).then((value) {
        print("added");
      });
    }
  }

  //get all teacher details
  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final id = querySnapshot.docs.map((doc) => doc.id).toList();
    usersData = allData;
    for (int i = 0; i < allData.length; i++) {
      usersData[i]["id"] = id[i];
    }
    print(usersData);
    setState(() {
      isLoading = false;
    });
    print(allData.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    //CardController controller; //Use this to trigger swap.

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      /*appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            "Finder",
            style: GoogleFonts.caramel(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 80,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
      ),*/
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 500,
                child: TinderSwapCard(
                  swipeUp: true,
                  swipeDown: true,
                  orientation: AmassOrientation.BOTTOM,
                  totalNum: usersData.length,
                  stackNum: 5,
                  animDuration: 50,
                  swipeEdge: 4.0,
                  maxWidth: 333,
                  maxHeight: 420,
                  minWidth: 330,
                  minHeight: 410,
                  cardBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    shadowColor: Colors.black,
                    elevation: 4,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => new DetailPage(type: img)));
                      /*  Navigator.of(context).push(_createRoute(
                            usersData[index]['picture']['large'],
                            usersData[index]['name']['first'],
                            usersData[index]['email'],
                            usersData[index]['location']['country']));*/
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius:
                                  45, // Change this radius for the width of the circular border
                              backgroundColor: Colors.black12,
                              child: CircleAvatar(
                                radius: 42,
                                backgroundImage: NetworkImage(
                                  "https://images.pexels.com/photos/3532552/pexels-photo-3532552.jpeg?cs=srgb&dl=pexels-hitesh-choudhary-3532552.jpg&fm=jpg",
                                  //usersData[index]['picture']['large'],
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              usersData[index]['email'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              usersData[index]['department'],
                              style: const TextStyle(
                                color: Color.fromRGBO(102, 102, 102, 1),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              usersData[index]['desc'],
                              style: const TextStyle(
                                color: Color.fromRGBO(102, 102, 102, 1),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 130,
                            ),
                            Container(
                              height: 2,
                              color: Colors.black.withOpacity(0.25),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (liked == false) {
                                      setState(() {
                                        liked = true;
                                      });
                                    } else {
                                      setState(() {
                                        liked = false;
                                      });
                                    }
                                  },
                                  icon: (liked == true)
                                      ? Icon(
                                          Icons.thumb_up,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.25),
                                        )
                                      : Icon(
                                          Icons.thumb_up_alt_outlined,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (liked == false) {
                                      setState(() {
                                        liked = true;
                                      });
                                    } else {
                                      setState(() {
                                        liked = false;
                                      });
                                    }
                                  },
                                  icon: (liked == true)
                                      ? Icon(
                                          Icons.bookmark,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.25),
                                        )
                                      : Icon(
                                          Icons.bookmark_outline_sharp,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //cardController: controller = CardController(),
                  swipeUpdateCallback:
                      (DragUpdateDetails details, Alignment align) {
                    /// Get swiping card's alignment
                    if (align.x < 0) {
                      print(align.x);
                      print(align.y);
                      print('left');
                      //Card is LEFT swiping
                    } else if (align.x > 0) {
                      print(align.x);
                      print(align.y);
                      //Card is RIGHT swiping
                      print('right');
                    }
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    if (orientation.name == "UP") {
                      print('up');
                    }
                    if (orientation.name == "RIGHT") {
                      print('right');
                      right(usersData[index]["id"]);
                    }
                    //print(index);
                    //print(usersData.length - 1);
                    if (index == usersData.length - 1) {
                      setState(() {
                        isLoading = true;
                        getData();
                      });
                    }

                    /// Get orientation & index of swiped card!
                  },
                ),
              ),
      ),
    );
  }
}

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('students');
  bool isLoading = true;
  late List usersData = [];
  final CollectionReference _rightRef =
      FirebaseFirestore.instance.collection('teachers');
  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final id = querySnapshot.docs.map((doc) => doc.id).toList();
    usersData = allData;
    for (int i = 0; i < allData.length; i++) {
      usersData[i]["id"] = id[i];
    }
    print(usersData);
    setState(() {
      isLoading = false;
    });
    print(allData.length);
  }

  Future<void> match(String email) async {
    late List rightS = [];
    late List uid = [];
    late List l = [];
    User? currentUser = FirebaseAuth.instance.currentUser;
    //print(currentUser!.uid);
    // Get id's of students who right_swiped particular teacher
    QuerySnapshot querySnapshotRight = await _rightRef
        .doc("76hHbmHggvOYdxoWUPPd")
        .collection("right_swipe")
        .get();
    final rightSwipe =
        querySnapshotRight.docs.map((doc) => doc.data()).toList();
    uid = rightSwipe;
    l = uid[0]["uid"];
    for (int i = 0; i < l.length; i++) {
      rightS.add(l[i]["uid"]);
    }
    if (rightS.contains(email)) {
      print("matched");
    } else {
      print("not matched");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool liked = false;

  @override
  Widget build(BuildContext context) {
    //CardController controller; //Use this to trigger swap.

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      /*appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            "Finder",
            style: GoogleFonts.caramel(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 80,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
      ),*/
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 500,
                child: TinderSwapCard(
                  swipeUp: true,
                  swipeDown: true,
                  orientation: AmassOrientation.BOTTOM,
                  totalNum: usersData.length,
                  stackNum: 5,
                  animDuration: 50,
                  swipeEdge: 4.0,
                  maxWidth: 333,
                  maxHeight: 420,
                  minWidth: 330,
                  minHeight: 410,
                  cardBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    shadowColor: Colors.black,
                    elevation: 4,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => new DetailPage(type: img)));
                       /* Navigator.of(context).push(_createRoute(
                            usersData[index]['picture']['large'],
                            usersData[index]['name']['first'],
                            usersData[index]['email'],
                            usersData[index]['location']['country']));*/
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius:
                                  45, // Change this radius for the width of the circular border
                              backgroundColor: Colors.black12,
                              child: CircleAvatar(
                                radius: 42,
                                backgroundImage: NetworkImage(
                                  "https://images.pexels.com/photos/3532552/pexels-photo-3532552.jpeg?cs=srgb&dl=pexels-hitesh-choudhary-3532552.jpg&fm=jpg",
                                  //usersData[index]['picture']['large'],
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              usersData[index]['email'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              usersData[index]['department'],
                              style: const TextStyle(
                                color: Color.fromRGBO(102, 102, 102, 1),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              usersData[index]['desc'],
                              style: const TextStyle(
                                color: Color.fromRGBO(102, 102, 102, 1),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 130,
                            ),
                            Container(
                              height: 2,
                              color: Colors.black.withOpacity(0.25),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (liked == false) {
                                      setState(() {
                                        liked = true;
                                      });
                                    } else {
                                      setState(() {
                                        liked = false;
                                      });
                                    }
                                  },
                                  icon: (liked == true)
                                      ? Icon(
                                          Icons.thumb_up,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.25),
                                        )
                                      : Icon(
                                          Icons.thumb_up_alt_outlined,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (liked == false) {
                                      setState(() {
                                        liked = true;
                                      });
                                    } else {
                                      setState(() {
                                        liked = false;
                                      });
                                    }
                                  },
                                  icon: (liked == true)
                                      ? Icon(
                                          Icons.bookmark,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.25),
                                        )
                                      : Icon(
                                          Icons.bookmark_outline_sharp,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //cardController: controller = CardController(),
                  swipeUpdateCallback:
                      (DragUpdateDetails details, Alignment align) {
                    /// Get swiping card's alignment
                    if (align.x < 0) {
                      print(align.x);
                      print(align.y);
                      print('left');
                      //Card is LEFT swiping
                    } else if (align.x > 0) {
                      print(align.x);
                      print(align.y);
                      //Card is RIGHT swiping
                      print('right');
                    }
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    if (orientation.name == "UP") {
                      print('up');
                    }
                    if (orientation.name == "RIGHT") {
                      print('right');
                      match(usersData[index]["email"]);
                    }
                    print(index);
                    print(usersData.length - 1);
                    if (index == usersData.length - 1) {
                      setState(() {
                        isLoading = true;
                        getData();
                      });
                    }

                    /// Get orientation & index of swiped card!
                  },
                ),
              ),
      ),
    );
  }
}
/*

Route _createRoute(String pic, String name, String email, String location) {
  return MaterialPageRoute(
    builder: (context) =>
        DetailPage(pic: pic, name: name, email: email, location: location),
  );
}
*/
