import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matriapp/Screens/Information.dart';
import 'package:matriapp/Screens/Tab.dart';
import 'package:matriapp/models/user_model.dart';
import 'package:matriapp/util/color.dart';
import 'Online.dart';
import 'Trending.dart';

class HomePage extends StatefulWidget {
  final Uuser currentUser;
  final List<Uuser> matches;
  final List<Uuser> usersAll;
  HomePage(this.currentUser, this.matches, this.usersAll);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  CollectionReference matchReference;
  @override
  void initState() {
    matchReference = db.collection("Users");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     'Messages',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 18.0,
      //       fontWeight: FontWeight.bold,
      //       letterSpacing: 1.0,
      //     ),
      //   ),
      //   elevation: 0.0,
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Online(widget.currentUser, widget.matches),
                Divider(),
                Trending(widget.currentUser, widget.usersAll),

                // RecentChats(widget.currentUser, widget.newmatches),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
