import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderr/pages/profile.dart';
import 'package:finderr/pages/roles.dart';
import 'package:finderr/pages/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/FirebaseHelper.dart';
import '../models/UserModel.dart';
import 'notifications.dart';

class NavBar extends StatefulWidget {
  final String user;
  const NavBar({super.key, required this.user});
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
   String?  email = "email";
   String? name = "name";
   String? pic = "https://www.iiitdm.ac.in/Profile/images/Profile/msm17b016.jpeg";
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;
  UserModel? thisUserModel;
  Future getData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      UserModel? thisUserModel =
          await FirebaseHelper.getUserModelById(currentUser.email.toString());
      print(thisUserModel!.profilepic);
      setState(() {
        email = thisUserModel.email;
        name = thisUserModel.fullname;
        if(thisUserModel.profilepic != ""){
          pic = thisUserModel.profilepic;
        }
      });
    }
  }

   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     getData();
   }
   notifications() async {
     User? currentUser = FirebaseAuth.instance.currentUser;
     if (currentUser != null) {
       UserModel? thisUserModel =
       await FirebaseHelper.getUserModelById(currentUser.email.toString());
     }
     String? role;
     var tea = await FirebaseFirestore
         .instance
         .collection("teachers")
         .doc(widget.user)
         .get();
     var stu = await FirebaseFirestore
         .instance
         .collection("students")
         .doc(widget.user)
         .get();
     if (tea.exists) {
       role = "teachers";
     } else if (stu.exists) {
       role = "students";
     }
     (role == "teachers")
         ?
     // ignore: use_build_context_synchronously
     Navigator.push(context, MaterialPageRoute(
         builder: (context) =>
             Notifications(
                 role: "teachers",
                 doc_id: widget.user),),)
         :
     // ignore: use_build_context_synchronously
     Navigator.push(context, MaterialPageRoute(
         builder: (context) => Notifications(
             role: "students",
             doc_id:widget.user),),);
   }
   pro() async {
     User? currentUser = FirebaseAuth.instance.currentUser;
     if (currentUser != null) {
       UserModel? thisUserModel =
       await FirebaseHelper.getUserModelById(currentUser.email.toString());
     }
     String? role;
     var tea = await FirebaseFirestore
         .instance
         .collection("teachers")
         .doc(widget.user)
         .get();
     var stu = await FirebaseFirestore
         .instance
         .collection("students")
         .doc(widget.user)
         .get();
     if (tea.exists) {
       role = "teachers";
     } else if (stu.exists) {
       role = "students";
     }
     (role == "teachers")
         ?
     // ignore: use_build_context_synchronously
     Navigator.push(context, MaterialPageRoute(
       builder: (context) =>
           const profile(
               role: "teachers",),),)
         :
     // ignore: use_build_context_synchronously
     Navigator.push(context, MaterialPageRoute(
       builder: (context) => const profile(
           role: "students",),),);
   }
   signOut() async {
    await auth.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const Roles();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [

          UserAccountsDrawerHeader(

            accountName: Text(
              name.toString(),
              style:GoogleFonts.baskervville(
    textStyle: const TextStyle(
    color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w600,
    ),
    ),
            ),
            accountEmail: Text(
              email.toString(),
              style: GoogleFonts.baskervville(
              textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    ),
    ),

            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  pic.toString(),
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),

              ),
            ),

            decoration:  BoxDecoration(
              color: Theme.of(context).backgroundColor,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(""),

              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.favorite),
            title:  Text('Wishlist',  style: GoogleFonts.varelaRound(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const wishlist())),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title:  Text('Profile',style: GoogleFonts.varelaRound(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),),
            onTap: () => pro(),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title:  Text('Notifications',style: GoogleFonts.varelaRound(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),),
            /*trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: const Center(
                  child: Text(
                    '8',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),*/
            onTap: () => notifications(),
          ),
          ListTile(
            title:  Text('Sign out',style: GoogleFonts.varelaRound(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => signOut(),
          ),
        ],
      ),
    );
  }


}
