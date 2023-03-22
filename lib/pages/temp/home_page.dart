
import 'package:finderr/pages/direct.dart';
import 'package:finderr/pages/profile.dart';
import 'package:finderr/pages/temp/cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/FirebaseHelper.dart';
import '../../models/UserModel.dart';
import 'getDet.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(68, 170, 255, 1),
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(105, 187, 255, 1),
          size: 20.0,
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(105, 187, 255, 1),
        backgroundColor: const Color.fromRGBO(186, 224, 255, 1),
        splashColor: const Color.fromRGBO(246, 246, 246, 1),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color.fromRGBO(105, 187, 255, 1),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int pageIndex = 0;
  bool pressed = false;
  bool det = false;
  final pages = [
    const cards(),
    const Choice(role: "teachers"),
  ];
  final List<Color> colors = [
    Color.fromRGBO(186, 224, 255, 1),
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[pageIndex],
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(15),
      height: size.width * .155,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.20),
            blurRadius: 20,
            offset: const Offset(0, 15),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.home,
                    color: Color.fromRGBO(68, 170, 255, 1),
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Color.fromRGBO(232, 232, 232, 1),
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () async {
              User? currentUser = FirebaseAuth.instance.currentUser;
              UserModel? userModel = await FirebaseHelper.getUserModelById(currentUser!.email.toString());
              setState(() {
                pressed = true;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => direct(userModel: userModel,)));
                pressed = false;
              });
            },
            icon: pressed == true
                ? const Icon(
                    Icons.message,
                    color: Color.fromRGBO(68, 170, 255, 1),
                    size: 35,
                  )
                : const Icon(
                    Icons.message_outlined,
                    color: Color.fromRGBO(232, 232, 232, 1),
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.person,
                    color: Color.fromRGBO(68, 170, 255, 1),
                    size: 35,
                  )
                : const Icon(
                    Icons.person_outlined,
                    color: Color.fromRGBO(232, 232, 232, 1),
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                det = true;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  const profile(role: "",)));
                det = false;
              });
            },
            icon: det == true
                ? const Icon(
                    Icons.settings,
                    color: Color.fromRGBO(68, 170, 255, 1),
                    size: 35,
                  )
                : const Icon(
                    Icons.settings_outlined,
                    color: Color.fromRGBO(232, 232, 232, 1),
                    size: 35,
                  ),
          ),
        ],
      ),
    );
  }
}
