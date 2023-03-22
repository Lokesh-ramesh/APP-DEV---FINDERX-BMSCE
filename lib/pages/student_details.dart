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
import '../models/FirebaseHelper.dart';
import '../models/UIHelper.dart';
import '../models/UserModel.dart';
import '../models/studentModel.dart';

class Student_details extends StatefulWidget {
  Student_details({Key? key}) : super(key: key);

  @override
  State<Student_details> createState() => _Student_detailsState();
}

class _Student_detailsState extends State<Student_details> {
  List? _myActivities;
  late String _myActivitiesResult;
  List? _myActivities1;
  List? _myActivities2;
  late String _myActivitiesResult1;
  late String _myActivitiesResult2;
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();
  final List<dynamic> textFieldsValue = [];
  File? imageFile;
  UserModel? thisUserModel;

  void stud_details(String name, String department, String desc, List skills,
      List project_interest, String phone_number) async {
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
        .collection("users")
        .doc(thisUserModel!.email)
        .set({"fullname": name}, SetOptions(merge: true)).then(
            (value) => {
          print("name added")
        });
    await FirebaseFirestore.instance
        .collection("students")
        .doc(email)
        .update({"uid": uid,
      "desc": desc,
      "name": name,
      "email": email,
      "department": department,
      "skills": skills,
      "project_interest": project_interest,
      "phone_number": phone_number,})
        .then(
      (value) {
        print("student addded");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return  Scroll(role: "teachers",);
          }),
        );
      },
    );
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);
    print("$croppedImage,3");
    if (croppedImage != null) {
      setState(() {
        uploadData();
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a photo"),
                ),
              ],
            ),
          );
        });
  }

  void uploadData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      thisUserModel = await FirebaseHelper.getUserModelById(currentUser.email.toString());
    }

    UIHelper.showLoadingDialog(context, "Uploading image..");
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilePictures")
        .child(thisUserModel!.email.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;
    String? imageUrl = await snapshot.ref.getDownloadURL();
    print(imageUrl);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(thisUserModel!.email)
        .set({"profilepic": imageUrl}, SetOptions(merge: true)).then(
            (value) => {
              print("photo added")
            });
    await FirebaseFirestore.instance
        .collection("students")
        .doc(thisUserModel!.email)
        .set({"profilepic": imageUrl}, SetOptions(merge: true)).then(
            (value) => {
          print("photo added")
        });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _myActivities = [];
    _myActivities1 = [];
    _myActivities2 = [];
    _myActivitiesResult = '';
    _myActivitiesResult1 = '';
    _myActivitiesResult2 = '';
  }

  /*void _directUpdateImage(File? file) async {
    if (file == null) return;

    setState(() {
      _profilePicFile = file;
    });
  }
*/
  /*_saveForm() {
    var form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
      });
    }
  }*/
  TextEditingController names = TextEditingController();
  TextEditingController branch = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController proj = TextEditingController();
  TextEditingController lang = TextEditingController();
  TextEditingController desc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'PROFILE',
            style: GoogleFonts.crimsonPro(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 50,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 1.2,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /*EditableImage(
                      // Define the method that will run on the change process of the image.
                      onChange: (file) => _directUpdateImage(file),

                      // Define the source of the image.
                      image: _profilePicFile != null
                          ? Image.file(_profilePicFile!, fit: BoxFit.cover)
                          : null,

                      // Define the size of EditableImage.
                      size: 150.0,

                      // Define the Theme of image picker.
                      imagePickerTheme: ThemeData(
                        // Define the default brightness and colors.
                        primaryColor: Colors.white,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.white70,
                        iconTheme: const IconThemeData(color: Colors.black87),

                        // Define the default font family.
                        fontFamily: 'Georgia',
                      ),

                      // Define the border of the image if needed.
                      imageBorder:
                          Border.all(color: Colors.black87, width: 2.0),

                      // Define the border of the icon if needed.
                      editIconBorder:
                          Border.all(color: Colors.black87, width: 2.0),
                    ),*/
                    Stack(
                      children: [
                        CupertinoButton(
                          onPressed: () {},
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: (imageFile != null)
                                ? FileImage(imageFile!)
                                : null,
                            child: (imageFile == null)
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          right: -15,
                          top: 80,
                          child: CupertinoButton(
                            onPressed: () {
                              showPhotoOptions();
                            },
                            child: ClipOval(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 20,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey3,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: names,
                            decoration: const InputDecoration(
                              labelText: 'Student Name',
                              hintText: 'Enter Full Name',
                              prefixIcon: Icon(Icons.drive_file_rename_outline),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              textFieldsValue.add(value!);

                              return value.isEmpty
                                  ? 'Please enter full name'
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
                      key: formKey,
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
                              dialogTextStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.blue,
                              checkBoxCheckColor: Colors.white,
                              dialogShapeBorder: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                              title: const Text(
                                "Branch",
                                style: TextStyle(fontSize: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.length > 1) {
                                  return 'Please select one option';
                                } else {
                                  return null;
                                }
                              },
                              dataSource: const [
                                {
                                  "display": "CSE",
                                  "value": "CSE",
                                },
                                {
                                  "display": "ISE",
                                  "value": "ISE",
                                },
                                {
                                  "display": "ECE",
                                  "value": "ECE",
                                },
                                {
                                  "display": "ME",
                                  "value": "ME",
                                },
                                {
                                  "display": "AI/ML",
                                  "value": "AI/ML",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: const Text('Please choose one option'),
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
                          /* Container(
                 padding: EdgeInsets.all(8),
                 child: ElevatedButton(
                    child: Text('Save'),
                    onPressed: _saveForm,
                  ),
                ),*/
                          Container(
                            child: Text(_myActivitiesResult),
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: formKey4,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Phone number',
                              hintText: '10 digit phone number',
                              prefixIcon: Icon(Icons.phone_android),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter mobile number';
                              } else {
                                textFieldsValue.add(value);
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: formKey2,
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
                              dialogTextStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.blue,
                              checkBoxCheckColor: Colors.white,
                              dialogShapeBorder: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              title: const Text(
                                "Project Interests",
                                style: TextStyle(fontSize: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please select one or more options';
                                } else {
                                  return null;
                                }
                              },
                              dataSource: const [
                                {
                                  "display": "AI/ML",
                                  "value": "AI/ML",
                                },
                                {
                                  "display": "IMAGE PROCESSING",
                                  "value": "IMAGE PROCESSING",
                                },
                                {
                                  "display": "WEB DEV",
                                  "value": "WEB DEV",
                                },
                                {
                                  "display": "APP DEV",
                                  "value": "APP DEV",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              //  hintWidget: const Text('Please choose one or more'),
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
                      key: formKey1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(1),
                            child: MultiSelectFormField(
                              autovalidate: AutovalidateMode.disabled,
                              chipBackGroundColor: Theme.of(context).backgroundColor,
                              chipLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              dialogTextStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.blue,
                              checkBoxCheckColor: Colors.white,
                              dialogShapeBorder: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              title: const Text(
                                "Programming languages",
                                style: TextStyle(fontSize: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please select one or more options';
                                } else {
                                  return null;
                                }
                              },
                              dataSource: const [
                                {
                                  "display": "C",
                                  "value": "d",
                                },
                                {
                                  "display": "JAVA",
                                  "value": "JAVA",
                                },
                                {
                                  "display": "PYTHON",
                                  "value": "PYTHON",
                                },
                                {
                                  "display": "DJANGO",
                                  "value": "DJANGO",
                                },
                                {
                                  "display": "C++",
                                  "value": "C++",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              //  hintWidget: const Text('Please choose one or more'),
                              initialValue: _myActivities1,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _myActivities1 = value;
                                  textFieldsValue.add(_myActivities1);
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(1),
                            child: Text(_myActivitiesResult1),
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: formKey5,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Student Description',
                              hintText: 'Write about yourself',
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return 'Please select one or more options';
                              } else {
                                textFieldsValue.add(value);
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (formKey3.currentState!.validate() &&
                              formKey4.currentState!.validate() &&
                              formKey5.currentState!.validate() &&
                              formKey1.currentState!.validate() &&
                              formKey2.currentState!.validate() &&
                              formKey.currentState!.validate()) {
                            print(textFieldsValue);
                            stud_details(
                                textFieldsValue[3],
                                textFieldsValue[0][0],
                                textFieldsValue[5],
                                textFieldsValue[2],
                                textFieldsValue[1],
                                textFieldsValue[4]);
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                          }
                        },
                        child: const Text('SUBMIT'),
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
