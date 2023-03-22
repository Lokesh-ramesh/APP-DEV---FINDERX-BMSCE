
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class Content {
  final String? text;

  Content({this.text});
}

class swipe extends StatefulWidget {
  const swipe({Key? key}) : super(key: key);

  @override
  _swipeState createState() => _swipeState();
}

class _swipeState extends State<swipe> with SingleTickerProviderStateMixin {
  final String url = "https://randomuser.me/api/?results=50";
  bool isLoading = true;
  late List usersData;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
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
      print(usersData);
      if (usersData.isNotEmpty) {
        for (int i = 0; i < usersData.length; i++) {
          _swipeItems.add(SwipeItem(
              // content: Content(text: _names[i], color: _colors[i]),
              content: Content(text: usersData[i]['name']['first']),
              likeAction: () {
                _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text("Liked "),
                  //  content: Text("Liked ${_names[i]}"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              nopeAction: () {
                _scaffoldKey.currentState?.showSnackBar(SnackBar(
                  content: Text("Nope ${usersData[i]['name']['first']}"),
                  duration: const Duration(milliseconds: 500),
                ));
              },
              superlikeAction: () {
                _scaffoldKey.currentState?.showSnackBar(SnackBar(
                  content: Text("Superliked ${usersData[i]['name']['first']}"),
                  duration: const Duration(milliseconds: 500),
                ));
              },
              onSlideUpdate: (SlideRegion? region) async {
                print("Region $region");
              }));
        } //for loop
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
        isLoading = false;
      } //if
    }); // setState
  } // getData

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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          "FINDER",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 90,
                      child: SizedBox(
                        width: 343,
                        height: 430,
                        child: Card(
                          margin: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container()),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      child: SizedBox(
                        width: 343,
                        height: 420,
                        child: Card(
                          margin: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container()),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: SwipeCards(
                        matchEngine: _matchEngine!,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 343,
                                height: 420,
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     new MaterialPageRoute(
                                  /*  //         builder: (context) => new DetailPage(type: img)));
                                    Navigator.of(context).push(_createRoute(
                                        usersData[index]['picture']['large'],
                                        usersData[index]['name']['first'],
                                        usersData[index]['email'],
                                        usersData[index]['location']
                                            ['country']));*/
                                  },
                                  child: Card(
                                      margin: const EdgeInsets.all(16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
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
                                                  usersData[index]['picture']
                                                      ['large'],
                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              usersData[index]['name']['first']
                                                  .toString(),
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
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              usersData[index]['location']
                                                  ['country'],
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 80,
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (liked == false) {
                                                      liked = true;
                                                      _ani.forward();
                                                      usersData[index]['liked'] = 'true';
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
                                      )),
                                ),
                              ),
                            ],
                          );
                        },
                        onStackFinished: () {},
                        itemChanged: (SwipeItem item, int index) {
                          setState(() {
                            _ani.reverse();
                          });
                          print("item: ${item.content.text}, index: $index");
                        },
                        upSwipeAllowed: true,
                        fillSpace: true,
                      ),
                    ),
                  ],
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
}*/
