import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/pages/authentication/signUp.dart';
import 'package:finderr/pages/scroll.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../models/UIHelper.dart';

var uuid = const Uuid();

class Signin extends StatefulWidget {
  final role;
  const Signin({super.key, required this.role});
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  FlutterSecureStorage storage = new FlutterSecureStorage();
  bool seen = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else {
      logIn(email, password);
    }
  }

  /*late bool exist;
  Future<bool> checkExist(String docID) async {
    try {
      await FirebaseFirestore.instance.doc(widget.role).get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }*/
  void logIn(String email, String password) async {
    //print(widget.role);
    UserCredential? credential;
    var user = await FirebaseFirestore.instance
        .collection(widget.role)
        .doc(email)
        .get();
    if (user.exists) {
      try {
        // ignore: use_build_context_synchronously
        UIHelper.showLoadingDialog(context, "Logging In..");
        credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
       // print(credential.user!.uid);
      } on FirebaseAuthException catch (ex) {
        // Close the loading dialog
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        // Show Alert Dialog
        // ignore: use_build_context_synchronously
        UIHelper.showAlertDialog(
            context, "An error occured", ex.message.toString());
      }
      if (credential != null) {
        //String uid = credential.user!.uid;
       /* DocumentSnapshot userData =
            await FirebaseFirestore.instance.collection('users').doc(email).get();
        UserModel userModel =
            UserModel.fromMap(userData.data() as Map<String, dynamic>);*/

        // ignore: use_build_context_synchronously
        Navigator.popUntil(context, (route) => route.isFirst);
        // ignore: use_build_context_synchronously
        print(widget.role);
       // (widget.role == "students")?await storage.write(key: "role", value: "teachers"):storage.write(key: "role", value: "students");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {

            return  (widget.role == "students")?Scroll(role: "teachers",):Scroll(role: "students",);
          }),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      UIHelper.showAlertDialog(
          context, "An error occured", "Select Appropriate Role or Sign Up");
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.role);
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
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //const Center(child: Image(image: AssetImage('logo.png'))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage('assets/logo.png'),
                              height: 40,
                              width: 40,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Finderx",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w900),
                        ),
                        const Text("Welcome"),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0XFFEFF3F6),
                              borderRadius: BorderRadius.circular(100.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    offset: Offset(6, 2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0),
                                BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
                                    offset: Offset(-6, -2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.black54,
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Email"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0XFFEFF3F6),
                              borderRadius: BorderRadius.circular(100.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    offset: Offset(6, 2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0),
                                BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
                                    offset: Offset(-6, -2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            child: TextField(
                              controller: passwordController,
                              obscureText: seen,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.key_rounded,
                                  color: Colors.black54,
                                ),
                                border: InputBorder.none,
                                hintText: "Password",
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      //refresh UI
                                      if (seen) {
                                        //if seen == true, make it false
                                        seen = false;
                                      } else {
                                        seen =
                                            true; //if seen == false, make it true
                                      }
                                    });
                                  },
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 0),
                                  constraints: const BoxConstraints(),
                                  color: Colors.black,
                                  icon: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Text("Forgot Password ?"),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: CupertinoButton(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Theme.of(context).backgroundColor,
                                  onPressed: () {
                                    checkValues();
                                  },
                                  child: const Center(
                                      child: Text(
                                    "Log In",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                  ))),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text("Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup(
                                              role: widget.role,
                                            )));
                              },
                              child: Text("Sign up",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                  )),
                            ),
                          ],
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
