import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detail_teacher.dart';
import 'details.dart';

class Notifications extends StatefulWidget {
  final String doc_id;
  final String role;
  const Notifications({super.key, required this.role, required this.doc_id});
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    print(widget.doc_id);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.black,
              ))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(widget.role)
            .doc(widget.doc_id)
            .get()
            .asStream(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          List list = snapshot.data!["notifications"];
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext ctx, index) {
                    // Display the list item
                    return (list.isEmpty)
                        ? const Center(child: CircularProgressIndicator())
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection((widget.role == "teachers")
                                    ? "students"
                                    : "teachers")
                                .doc(snapshot.data?["notifications"][index])
                                .get()
                                .asStream(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snap) {
                              return (!snap.hasData)
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Dismissible(
                                      key: UniqueKey(),
                                      // only allows the user swipe from right to left
                                      direction: DismissDirection.startToEnd,
                                      // Remove this product from the list
                                      // In production enviroment, you may want to send some request to delete it on server side
                                      onDismissed: (_) {
                                        setState(
                                          () {
                                            FirebaseFirestore.instance
                                                .collection("students")
                                                .doc(widget.doc_id)
                                                .update({
                                              "notifications":
                                                  FieldValue.arrayRemove([
                                                snapshot.data!["notifications"]
                                                    [index]
                                              ])
                                            }).then((value) => () {
                                                      print("deleted");
                                                    });
                                          },
                                        );
                                      },
                                      // This will show up when the user performs dismissal action
                                      // It is a red background and a trash icon
                                      background: Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(15),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        alignment: Alignment.centerLeft,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),

                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          leading: ClipOval(
                                            child: Image(
                                              image: NetworkImage(
                                                  snap.data!["profilepic"]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(snap.data!["email"]),
                                          subtitle:
                                              Text(snap.data!["department"]),
                                          trailing: IconButton(
                                            onPressed: () async {
                                              String? role;
                                              var tea = await FirebaseFirestore
                                                  .instance
                                                  .collection("teachers")
                                                  .doc(snap.data?["email"]
                                                      .toString())
                                                  .get();
                                              var stu = await FirebaseFirestore
                                                  .instance
                                                  .collection("students")
                                                  .doc(snap.data?["email"]
                                                      .toString())
                                                  .get();
                                              if (tea.exists) {
                                                role = "teachers";
                                              } else if (stu.exists) {
                                                role = "students";
                                              }
                                              (role == "teachers")
                                                  ?
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Details_teach(
                                                                  role:
                                                                      "teachers",
                                                                  doc_id: snap
                                                                          .data![
                                                                      "email"])))
                                                  :
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Details(
                                                                  role:
                                                                      "students",
                                                                  doc_id: snap
                                                                          .data![
                                                                      "email"])));
                                            },
                                            icon:
                                                const Icon(Icons.arrow_forward),
                                          ),
                                        ),
                                      ),
                                    );
                            });
                  },
                );
        },
      ),
    );
  }
}
