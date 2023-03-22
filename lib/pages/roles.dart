import 'package:finderr/pages/authentication/signIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Roles extends StatefulWidget {
  const Roles({Key? key}) : super(key: key);

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  FlutterSecureStorage storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 01,
              colors: [
                Colors.blue[100]!,
                Colors.blue[100]!,
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white70.withOpacity(0.75)
                            .withOpacity(0.75), //color of shadow
                        spreadRadius: 2, //spread radius
                        blurRadius: 1, // blur radius
                        offset: const Offset(0, 2),
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Center(
                          child: Image(
                            image: AssetImage('assets/logo.png'),
                            height: 50,
                            width: 50,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'SELECT YOUR ROLE',
                                textStyle: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700]!.withOpacity(0.75),
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            totalRepeatCount: 3,
                            pause: const Duration(milliseconds: 100),
                            displayFullTextOnTap: false,
                            stopPauseOnTap: true,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue[700]!
                                      .withOpacity(0.75), //color of shadow
                                  spreadRadius: 2, //spread radius
                                  blurRadius: 1, // blur radius
                                  offset: const Offset(0, 2),
                                ),
                                //you can set more BoxShadow() here
                              ],
                            ),
                            child: CupertinoButton(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue[300],
                                onPressed: () async {
                                  storage.write(key: "disp_role", value: "teachers");
                                  //checkValues();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Signin(
                                        role: "students",
                                      ),
                                    ),
                                  );
                                },
                                child: Center(
                                    child: Column(
                                  children: const [
                                    //Icon(Icons.person,size: 100,),
                                    Image(
                                      image: AssetImage('assets/student.png'),
                                      height: 100,
                                      width: 100,
                                    ),
                                    Text(
                                      "STUDENT",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue[700]!
                                      .withOpacity(0.75), //color of shadow
                                  spreadRadius: 2, //spread radius
                                  blurRadius: 1, // blur radius
                                  offset: const Offset(0, 2),
                                ),
                                //you can set more BoxShadow() here
                              ],
                            ),
                            child: CupertinoButton(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue[300],
                                onPressed: () async  {
                                    storage.write(key: "disp_role", value: "students");
                                  //checkValues();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Signin(
                                        role: "teachers",
                                      ),
                                    ),
                                  );
                                },
                                child: Center(
                                    child: Column(
                                  children: const [
                                    Image(
                                      image: AssetImage('assets/teacher.png'),
                                      height: 100,
                                      width: 100,
                                    ),
                                    Text(
                                      "TEACHER",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
