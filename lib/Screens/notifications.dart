import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matriapp/Screens/Information.dart';
import 'package:matriapp/models/user_model.dart';
import 'package:matriapp/util/color.dart';

import 'Tab.dart';

class Notifications extends StatefulWidget {
  final Uuser currentUser;
  final List<Uuser> matches;

  Notifications(this.currentUser, this.matches);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final db = FirebaseFirestore.instance;
 // final dbb = FirebaseFirestore.instance;
  CollectionReference matchReference;
  CollectionReference likedReference;
  @override
  void initState() {
    matchReference = db
        .collection("Users")
        .doc(widget.currentUser.id)
        .collection('Matches');





    likedReference = db
        .collection("Users")
        .doc(widget.currentUser.id)
        .collection('LikedBy');




    // Future.delayed(Duration(seconds: 1), () {
    //   if (widget.notification.length > 1) {
    //     widget.notification.sort((a, b) {
    //       var adate = a.time; //before -> var adate = a.expiry;
    //       var bdate = b.time; //before -> var bdate = b.expiry;
    //       return bdate.compareTo(
    //           adate); //to get the order other way just switch `adate & bdate`
    //     });
    //   }
    // });
    // if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          // flexibleSpace: Container(
          //     decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //             colors: [pinkColor, primaryColor.withOpacity(.5)]))),
          title: Text(
            'Notifications',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          elevation: 0,
        ),
        //backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(50),
              //   topRight: Radius.circular(50),
              // ),
              color: Colors.white),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Matches (${widget.matches.length})',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: matchReference
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                            child: Text(
                          "No Notification",
                          style: TextStyle(color: secondryColor, fontSize: 16),
                        ));
                      else if (snapshot.data.docs.length == 0) {
                        return Center(
                            child: Text(
                          "No Notification",
                          style: TextStyle(color: secondryColor, fontSize: 16),
                        ));
                      }
                      return Expanded(
                        child: ListView(
                          children: snapshot.data.docs
                              .map((doc) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: !doc['isRead']
                                                ? primaryColor.withOpacity(.15)
                                                : secondryColor
                                                    .withOpacity(.15)),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(5),
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: secondryColor,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    doc['pictureUrl'] ??
                                                        "",
                                                fit: BoxFit.cover,
                                                useOldImageOnUrlChange: true,
                                                placeholder: (context, url) =>
                                                    CupertinoActivityIndicator(
                                                  radius: 20,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons.error,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            // backgroundImage:
                                            //     NetworkImage(
                                            //   widget.notification[index]
                                            //       .sender.imageUrl[0],
                                            // )
                                          ),
                                          title: Text(
                                              "you are matched with ${doc['userName'] ?? "__"}"),
                                          subtitle: Text(
                                              "${(doc['timestamp'].toDate())}"),
                                          //  Text(
                                          //     "Now you can start chat with ${notification[index].sender.name}"),
                                          // "if you want to match your profile with ${notifications[index].sender.name} just like ${notifications[index].sender.name}'s profile"),
                                          trailing: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                !doc['isRead']
                                                    ? Container(
                                                        width: 40.0,
                                                        height: 20.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                                pinkColor,
                                                                primaryColor
                                                                    .withOpacity(
                                                                        .5)
                                                              ]),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'NEW',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            print(doc["Matches"]);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ));
                                                });
                                            DocumentSnapshot userdoc = await db
                                                .collection("Users")
                                                .doc(doc["Matches"])
                                                .get();
                                            if (userdoc.exists) {
                                              Navigator.pop(context);
                                              Uuser tempuser =
                                                  Uuser.fromMap(userdoc.data());
                                              tempuser.distanceBW =
                                                  calculateDistance(
                                                          widget.currentUser
                                                                  .coordinates[
                                                              'latitude'],
                                                          widget.currentUser
                                                                  .coordinates[
                                                              'longitude'],
                                                          tempuser.coordinates[
                                                              'latitude'],
                                                          tempuser.coordinates[
                                                              'longitude'])
                                                      .round();

                                              await showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    if (!doc["isRead"]) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "/Users/${widget.currentUser.id}/Matches")
                                                          .doc(
                                                              '${doc["Matches"]}')
                                                          .update(
                                                              {'isRead': true});
                                                    }
                                                    return Info(
                                                        tempuser,
                                                        widget.currentUser,
                                                        null);
                                                  });
                                            }
                                          },
                                        )
                                        //  : Container()
                                        ),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Like Requests (${likedByList.length})',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream:
                    likedReference
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                            child: Text(
                              "No Data",
                              style: TextStyle(color: secondryColor, fontSize: 16),
                            ));
                      else if (snapshot.data.docs.length == 0) {
                        return Center(
                            child: Text(
                              "No Data",
                              style: TextStyle(color: secondryColor, fontSize: 16),
                            ));
                      }
                      return Expanded(
                        child: ListView(
                          children: snapshot.data.docs
                              .map((doc) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    color:  secondryColor
                                        .withOpacity(.15)),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(5),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: secondryColor,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                        25,
                                      ),
                                      child: CachedNetworkImage(

                                        imageUrl:
                                        doc['pictureUrl'] ??
                                            "",
                                        fit: BoxFit.cover,
                                        useOldImageOnUrlChange: true,
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                              radius: 20,
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                            Icon(
                                              Icons.error,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ),
                                    // backgroundImage:
                                    //     NetworkImage(
                                    //   widget.notification[index]
                                    //       .sender.imageUrl[0],
                                    // )
                                  ),
                                  title: Text(
                                      "${doc['userName'] ?? "__"} likes you"),
                                  subtitle: Text(
                                      "${(doc['timestamp'].toDate())}"),
                                  //  Text(
                                  //     "Now you can start chat with ${notification[index].sender.name}"),
                                  // "if you want to match your profile with ${notifications[index].sender.name} just like ${notifications[index].sender.name}'s profile"),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        !doc['isRead']
                                            ? Container(
                                          width: 40.0,
                                          height: 20.0,
                                          decoration:
                                          BoxDecoration(
                                            gradient:
                                            LinearGradient(
                                                colors: [
                                                  pinkColor,
                                                  primaryColor
                                                      .withOpacity(
                                                      .5)
                                                ]),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                30.0),
                                          ),
                                          alignment:
                                          Alignment.center,
                                          child: Text(
                                            'NEW',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        )
                                            : Text(""),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    print(doc["Matches"]);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                              child:
                                              CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(
                                                    Colors.white),
                                              ));
                                        });
                                    DocumentSnapshot userdoc = await db
                                        .collection("Users")
                                        .doc(doc["LikedBy"])
                                        .get();
                                    if (userdoc.exists) {
                                      Navigator.pop(context);
                                      Uuser tempuser =
                                      Uuser.fromMap(userdoc.data());
                                      tempuser.distanceBW =
                                          calculateDistance(
                                              widget.currentUser
                                                  .coordinates[
                                              'latitude'],
                                              widget.currentUser
                                                  .coordinates[
                                              'longitude'],
                                              tempuser.coordinates[
                                              'latitude'],
                                              tempuser.coordinates[
                                              'longitude'])
                                              .round();

                                      await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            if (!doc["isRead"]) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                  "/Users/${widget.currentUser.id}/LikedBy")
                                                  .doc(
                                                  '${doc["LikedBy"]}')
                                                  .update(
                                                  {'isRead': true});
                                            }
                                            return Info(
                                                tempuser,
                                                widget.currentUser,
                                                null);
                                          });
                                    }
                                  },
                                )
                              //  : Container()
                            ),
                          ))
                              .toList(),
                        ),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
