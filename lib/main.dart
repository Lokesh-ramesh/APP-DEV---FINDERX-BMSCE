import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/pages/launch.dart';
import 'package:finderr/pages/roles.dart';
import 'package:finderr/pages/scroll.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'models/FirebaseHelper.dart';
import 'models/UserModel.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Splash());
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  check() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Logged In
      UserModel? thisUserModel =
          await FirebaseHelper.getUserModelById(currentUser.email.toString());
      if (thisUserModel != null) {
        runApp(
            MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
      } else {
        runApp(const MyApp());
      }
    } else {
      // Not logged in
      runApp(const MyApp());
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = Tween<double>(begin: 0, end: 430).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.isCompleted;
        }
      });
    controller.forward();
    Timer(const Duration(seconds: 3), () => check());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: animation.value,
              height: animation.value,
            ),
            /*Text(
              'Finder X BMSCE',
              style: TextStyle(
                color: Colors.black.withOpacity(0.75),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const CircularProgressIndicator(color: Colors.black,)*/
          ],
        ),
      ),
    );
  }
}

// Not Logged In
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetStartedView(),
    );
  }
}

// Already Logged In
class MyAppLoggedIn extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<MyAppLoggedIn> createState() => _MyAppLoggedInState();
}

class _MyAppLoggedInState extends State<MyAppLoggedIn> {
  String? role;
  Future<void> checkData() async {
    print(role);
    var tea = await FirebaseFirestore.instance
        .collection("teachers")
        .doc(widget.userModel.email.toString())
        .get();
    var stu = await FirebaseFirestore.instance
        .collection("students")
        .doc(widget.userModel.email.toString())
        .get();
    if (tea.exists) {
      print("exits");
      role = "students";
    } else if (stu.exists) {
      role = "teachers";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scroll(
        role: role,
      ),
    );
  }
}
