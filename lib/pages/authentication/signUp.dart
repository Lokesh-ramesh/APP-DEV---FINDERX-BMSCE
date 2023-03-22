import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/models/studentModel.dart';
import 'package:finderr/pages/student_details.dart';
import 'package:finderr/pages/teacher_details.dart';
import 'package:finderr/pages/temp/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/UIHelper.dart';
import '../../models/teacherModel.dart';
import '../../models/UserModel.dart';

class Signup extends StatefulWidget {
  final role;
  const Signup({super.key, required this.role});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool seen = true;
  bool seenp = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else if (password != cPassword) {
      UIHelper.showAlertDialog(context, "Password Mismatch",
          "The passwords you entered do not match!");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return Signin();
    //   }),
    //);

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);

      UIHelper.showAlertDialog(
          context, "An error occured", ex.message.toString());
    }

    UIHelper.showLoadingDialog(context, "Creating new account..");

    if (credential != null) {
      String uid = credential.user!.uid;
      if (widget.role == "teachers") {
        TeacherModel newTeacher = TeacherModel(
            uid: uid,
            desc: "",
            name: "",
            phone: "",
            email: email,
            pass: password,
            department: "",
            project_available: [],
            notifications: []);
        await FirebaseFirestore.instance
            .collection("teachers")
            .doc(email)
            .set(newTeacher.toMap())
            .then((value) {
          print("teacher addded");
        });
      }
      if (widget.role == "students") {
        StudentModel newStudent = StudentModel(
            uid: uid,
            desc: "",
            name: "",
            email: email,
            pass: password,
            department: "",
            skills: [],
            project_interest: [],
            phone_number: "",
            notifications: []);
        await FirebaseFirestore.instance
            .collection("students")
            .doc(email)
            .set(newStudent.toMap())
            .then((value) {
          print("student addded");
        });
      }
      UserModel newUser = UserModel(
          uid: uid, email: email, fullname: "", pass: password, profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .set(newUser.toMap())
          .then((value) {
        //print("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return (widget.role == "students")
                ? Student_details()
                : teacher_details();
          }),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.role);
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
                        const Text("Welcome"),
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w900),
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
                              obscureText: seenp,
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
                                      if (seenp) {
                                        //if seen == true, make it false
                                        seenp = false;
                                      } else {
                                        seenp =
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
                                vertical: 0.0, horizontal: 5.0),
                            child: TextField(
                              controller: cPasswordController,
                              obscureText: seen,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.key_rounded,
                                  color: Colors.black54,
                                ),
                                border: InputBorder.none,
                                hintText: "Confirm Password",
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
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                  ))),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text("Already have an account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text("Sign in",
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
