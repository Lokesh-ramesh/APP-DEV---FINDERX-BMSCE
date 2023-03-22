

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/pages/scroll.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:editable_image/editable_image.dart';
// import '../models/FirebaseHelper.dart';
// import '../models/UIHelper.dart';
import '../../models/FirebaseHelper.dart';
import '../../models/UIHelper.dart';
import '../../models/UserModel.dart';
//import '../models/UserModel.dart';
// import '../models/studentModel.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: projectdetails(),
    ),
  );
}

class projectdetails extends StatefulWidget {
  projectdetails({Key? key}) : super(key: key);

  @override
  State<projectdetails> createState() => _projectdetailsState();
}

class _projectdetailsState extends State<projectdetails> {

  List? _myActivities;
  late String _myActivitiesResult;
  List? _myActivities2;
  late String _myActivitiesResult2;

  final formKey10 = GlobalKey<FormState>();
  final formKey11 = GlobalKey<FormState>();
  final formKey12 = GlobalKey<FormState>();
  final formKey13 = GlobalKey<FormState>();
  final formKey14 = GlobalKey<FormState>();



  final List<dynamic> textFieldsValue = [];
  UserModel? thisUserModel;
  void projectdetails(String projectname, List projectduration, List projectdomain,
      String prerequisites,String desc) async {
    UserModel? thisUserModel;
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Logged In
      thisUserModel = await FirebaseHelper.getUserModelById(currentUser.email.toString());
    }
    String? uid = thisUserModel?.uid;
    String? email = thisUserModel?.email;
    print(thisUserModel?.uid);
    UIHelper.showLoadingDialog(context, "Completing Profile..");
    await FirebaseFirestore.instance
        .collection("teachers")
        .doc(email)
        .set(
        {
         // "uid": uid,
           // "projectname": projectname,
          "project_available": projectdomain,
       "desc": desc,
      //"prerequisites": prerequisites,
    },
    SetOptions(
      merge: true,
    ),
    )
        .then(
          (value) {
        print("student addded");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return  Scroll(role: email.toString(),);
          }),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    _myActivities = [];


    _myActivitiesResult = '';

    _myActivitiesResult2 = '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              )),
          centerTitle: true,
          title: Text(
            'PROJECT DETAILS',
            style: GoogleFonts.baskervville(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: formKey10,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Project Name',
                              hintText: 'Enter the Project Name',
                              prefixIcon:
                              Icon(Icons.library_books),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              textFieldsValue.add(value!);

                              return value!.isEmpty
                                  ? 'Please enter project name'
                                  : null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: formKey11,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(1.5),
                            child: MultiSelectFormField(
                              autovalidate: AutovalidateMode.disabled,
                              chipBackGroundColor: Colors.blue,
                              chipLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              dialogTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.blue,
                              checkBoxCheckColor: Colors.white,
                              dialogShapeBorder: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                              title: const Text(
                                "Project Domain",
                                style: TextStyle(fontSize: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please select one option';
                                } else {
                                  return null;
                                }
                              },
                              dataSource: const [
                                {
                                  "display": "ML",
                                  "value": "ML",
                                },
                                {
                                  "display": "AI",
                                  "value": "AI",
                                },
                                {
                                  "display": "CyberSecurity",
                                  "value": "CyberSecurity",
                                },
                                {
                                  "display": "Image Processing",
                                  "value": "Image Processing",
                                },
                                {
                                  "display": "Web Dev",
                                  "value": "Web Dev",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: const Text('Please select one option'),
                              initialValue: _myActivities,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _myActivities = value;
                                  textFieldsValue.add(_myActivities);
                                });
                              },
                            ),
                          ),

                          Container(
                            child: Text(_myActivitiesResult),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Form(
                      key: formKey12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(1),
                            child: MultiSelectFormField(
                              autovalidate: AutovalidateMode.disabled,
                              chipBackGroundColor: Colors.blue,
                              chipLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              dialogTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.blue,
                              checkBoxCheckColor: Colors.white,
                              dialogShapeBorder: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12.0))),
                              title: const Text(
                                "Project Duration",
                                style: TextStyle(fontSize: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please select one option';
                                } else {
                                  return null;
                                }
                              },
                              dataSource: const [
                                {
                                  "display": "1",
                                  "value": "1",
                                },
                                {
                                  "display": "2",
                                  "value": "2",
                                },
                                {
                                  "display": "3",
                                  "value": "3",
                                },
                                {
                                  "display": "4",
                                  "value": "4",
                                },
                                {
                                  "display": "5",
                                  "value": "5",
                                },
                                {
                                  "display": "6 or more",
                                  "value": "6 or more",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: const Text('Please select the duration in months'),
                              initialValue: _myActivities2,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _myActivities2 = value;
                                  textFieldsValue.add(_myActivities2);
                                });
                              },
                            ),
                          ),
                          Container(
                            child: Text(_myActivitiesResult2),
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: formKey13,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Pre -requisites',
                              hintText: 'Requirements',
                              prefixIcon:
                              Icon(Icons.book_online_sharp),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              textFieldsValue.add(value!);
                              return value!.isEmpty
                                  ? 'Please enter the pre-requisites'
                                  : null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: formKey14,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Project Description',
                              hintText: 'Description',
                              prefixIcon:
                              Icon(Icons.book_online_sharp),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              textFieldsValue.add(value!);
                              return value!.isEmpty
                                  ? 'Please enter the Project Description'
                                  : null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if ( formKey10.currentState!.validate() &&
                              formKey11.currentState!.validate() &&
                              formKey12.currentState!.validate() &&
                              formKey13.currentState!.validate() &&
                              formKey14.currentState!.validate()
                          ) {
                            print(textFieldsValue);
                            projectdetails(
                              textFieldsValue[2],
                              textFieldsValue[1],
                              textFieldsValue[0],
                              textFieldsValue[3],
                              textFieldsValue[4],

                            );
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                          }
                        },
                        child:  Text('SUBMIT',style: GoogleFonts.varelaRound(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
