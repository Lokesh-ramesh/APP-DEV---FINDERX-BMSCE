import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:lottie/lottie.dart';

//import 'detail.dart';

class cards extends StatefulWidget {
  const cards({super.key});

  @override
  _cardsState createState() => _cardsState();
}

class _cardsState extends State<cards> with TickerProviderStateMixin {
  final String url = "https://randomuser.me/api/?results=50";
  bool isLoading = true;
  late List usersData = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future getData() async {
    var response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
    );

    List data = jsonDecode(response.body)['results'];
    usersData = data;
    setState(() {
      isLoading = false;
    });
  }

  late AnimationController _ani;
  @override
  void initState() {
    super.initState();
    _ani = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50));
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ani.dispose();
  }

  bool liked = false;

  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SizedBox(
                  height: 500,
                  child: TinderSwapCard(
                    swipeUp: true,
                    swipeDown: true,
                    orientation: AmassOrientation.BOTTOM,
                    totalNum: usersData.length,
                    stackNum: 4,
                    animDuration: 50,
                    swipeEdge: 4.0,
                    maxWidth: 330,
                    maxHeight: 420,
                    minWidth: 320,
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
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius:
                                    45, // Change this radius for the width of the circular border
                                backgroundColor: Colors.black12,
                                child: CircleAvatar(
                                  radius: 42,
                                  backgroundImage: NetworkImage(
                                    // "https://images.pexels.com/photos/3532552/pexels-photo-3532552.jpeg?cs=srgb&dl=pexels-hitesh-choudhary-3532552.jpg&fm=jpg",
                                    usersData[index]['picture']['large'],
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                usersData[index]['name']['first'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                usersData[index]['email'],
                                style: const TextStyle(
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                usersData[index]['location']['country'],
                                style: const TextStyle(
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (liked == false) {
                                        liked = true;
                                        _ani.forward();
                                      } else {
                                        liked = false;
                                        _ani.reverse();
                                      }
                                    },
                                    child: Lottie.network(
                                      'https://assets3.lottiefiles.com/packages/lf20_llxa9mhh.json',
                                      width: 75,
                                      height: 75,
                                      controller: _ani,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    cardController: controller = CardController(),
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
                      print(index);

                      /// Get orientation & index of swiped card!
                    },
                  ),
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
