import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:matriapp/Screens/Chat/chatPage.dart';
import 'package:matriapp/models/user_model.dart';
import 'package:matriapp/Screens/Tab.dart';
import 'package:matriapp/Screens/Information.dart';
import 'package:matriapp/util/color.dart';

class Trending extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final Uuser currentUser;
  final List<Uuser> usersAll;

  Trending(this.currentUser, this.usersAll);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Trending Users',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            //  height: MediaQuery.of(context).size.height,
             height: 356,
          //height: MediaQuery.of(context).size.height,
              child: usersAll.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(left: 0.0),
                      // scrollDirection: Axis.vertical,
                       itemCount: usersAll.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                // borderRadius:
                                //     BorderRadius.circular(20),
                                  color:
                                  secondryColor.withOpacity(.20)),
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
                                      imageUrl: usersAll[index].imageUrl[0] ?? '',
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
                                    "${usersAll[index].name ?? "__"}"),
                                // subtitle: Text(
                                //     "${(doc.data['timestamp'].toDate())}"),
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
                                      Container(
                                        width: 50.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                pinkColor,
                                                appColor
                                              ]),
                                          // borderRadius:
                                          //     BorderRadius.circular(
                                          //         20.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${usersAll[index].editInfo["type"] == "offer" ? "Offer" : usersAll[index].editInfo["type"] == "demand" ? "Demand" : "New"}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  //print(doc.data["userId"]);
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
                                      .doc(usersAll[index].id)
                                      .get();
                                  if (userdoc.exists) {
                                    Navigator.pop(context);
                                    Uuser tempuser =
                                    Uuser.fromMap(userdoc.data());
                                    tempuser.distanceBW =
                                        calculateDistance(
                                            currentUser
                                                .coordinates[
                                            'latitude'],
                                            currentUser
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
                                          return Info(
                                              tempuser,
                                              currentUser,
                                              null);
                                        });
                                  }
                                },
                              )
                            //  : Container()
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                      "No user found",
                      style: TextStyle(color: secondryColor, fontSize: 16),
                    ))),
        ],
      ),
    );
  }
}

var groupChatId;
chatId(currentUser, sender) {
  if (currentUser.id.hashCode <= sender.id.hashCode) {
    return groupChatId = '${currentUser.id}-${sender.id}';
  } else {
    return groupChatId = '${sender.id}-${currentUser.id}';
  }
}
