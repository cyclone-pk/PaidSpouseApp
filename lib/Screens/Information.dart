import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:matriapp/Screens/Chat/Matches.dart';
import 'package:matriapp/Screens/Profile/EditProfile.dart';
import 'package:matriapp/Screens/reportUser.dart';
import 'package:matriapp/models/user_model.dart';
import 'package:matriapp/util/color.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:matriapp/Screens/Tab.dart';

import 'Chat/chatPage.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class DetailScreen extends StatelessWidget {
  final String url;

  DetailScreen({Key key, @required this.url})
      : assert(url != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Image.network(
            url,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class Info extends StatelessWidget {
  final Uuser currentUser;
  final Uuser user;

  final GlobalKey<SwipeStackState> swipeKey;
  Info(
    this.user,
    this.currentUser,
    this.swipeKey,
  );

  @override
  Widget build(BuildContext context) {
    bool isMe = user.id == currentUser.id;
    bool isMatched = swipeKey == null;
    bool matched = false;
    if (matchedByList
        .contains(user.id)) {
      matched = true;

    }


    Future updateData() async {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(user.id)
          .set({'visits': FieldValue.increment(1)},
          SetOptions(merge: true));
    }
    updateData();
    //  if()

    //matches.any((value) => value.id == user.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Videos',
                          style: TextStyle(
                            color: primaryColor,
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
        user.videoUrl.length >0
    ?
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Swiper(
                      key: UniqueKey(),
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index2) {
                        return user.videoUrl.length != null
                            ? Hero(
                                tag: "abc",
                                child: VideoWidget(
                                    play: true,
                                    url: user.videoUrl[index2] ?? ''),
                              )
                            : Container();
                      },
                      itemCount: user.videoUrl.length,
                      // pagination: new SwiperPagination(
                      //     alignment: Alignment.bottomCenter,
                      //     builder: DotSwiperPaginationBuilder(
                      //         activeSize: 13,
                      //         color: secondryColor,
                      //         activeColor: primaryColor)),
                      control: new SwiperControl(
                        color: primaryColor,
                        disableColor: secondryColor,
                      ),
                      loop: false,
                    ),
                  )
            :
                      Container(child: Text("User not uploaded any video"),)
                ,

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Images',
                          style: TextStyle(
                            color: primaryColor,
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
                      height: 100.0,
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 10.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: user.imageUrl.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                    return DetailScreen(
                                        url: user.imageUrl[index] ?? '');
                                  }));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: secondryColor,
                                    radius: 35.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: CachedNetworkImage(
                                        imageUrl: user.imageUrl[index] ?? '',
                                        useOldImageOnUrlChange: true,
                                        placeholder: (context, url) =>
                                            CupertinoActivityIndicator(
                                              radius: 15,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            subtitle: Text("${user.address}"),
                            title: Text(
                              "${user.name}, ${user.editInfo['showMyAge'] != null ? !user.editInfo['showMyAge'] ? user.age : "" : user.age}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: primaryColor,
                                )),

                          ),


                          user.editInfo['offer'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.card_giftcard,
                                      color: primaryColor),
                                  title: Text(
                                    "Offer: ${user.editInfo['offer']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),

                          user.editInfo['demand'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.arrow_circle_up,
                                      color: primaryColor),
                                  title: Text(
                                    "Demand: ${user.editInfo['demand']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['interests'] != null
                              ? ListTile(
                                  dense: true,
                                  leading:
                                      Icon(Icons.label, color: primaryColor),
                                  title: Text(
                                    "Interests: ${user.editInfo['interests']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['profession'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.card_membership,
                                      color: primaryColor),
                                  title: Text(
                                    "Profession: ${user.editInfo['profession']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['job_title'] != null
                              ? ListTile(
                                  dense: true,
                                  leading:
                                      Icon(Icons.work, color: primaryColor),
                                  title: Text(
                                    "Job: ${user.editInfo['job_title']}${user.editInfo['company'] != null ? ' at ${user.editInfo['company']}' : ''}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['salary'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.money_rounded,
                                      color: primaryColor),
                                  title: Text(
                                    "Salary: ${user.editInfo['salary']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['marital_status'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.insert_drive_file,
                                      color: primaryColor),
                                  title: Text(
                                    "Marital Status: ${user.editInfo['marital_status']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['cast'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(
                                      Icons.supervised_user_circle_sharp,
                                      color: primaryColor),
                                  title: Text(
                                    "Cast: ${user.editInfo['cast']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['height'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.arrow_circle_up,
                                      color: primaryColor),
                                  title: Text(
                                    "Height: ${user.editInfo['height']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['weight'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.line_weight,
                                      color: primaryColor),
                                  title: Text(
                                    "Weight: ${user.editInfo['weight']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['color'] != null
                              ? ListTile(
                                  dense: true,
                                  leading:
                                      Icon(Icons.face, color: primaryColor),
                                  title: Text(
                                    "Color: ${user.editInfo['color']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['university'] != null
                              ? ListTile(
                                  dense: true,
                                  leading:
                                      Icon(Icons.stars, color: primaryColor),
                                  title: Text(
                                    "Qualification: ${user.editInfo['university']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['living_in'] != null
                              ? ListTile(
                                  dense: true,
                                  leading:
                                      Icon(Icons.home, color: primaryColor),
                                  title: Text(
                                    "Living in ${user.editInfo['living_in']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          !isMe
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.location_on,
                                    color: primaryColor,
                                  ),
                                  title: Text(
                                    "${user.editInfo['DistanceVisible'] != null ? user.editInfo['DistanceVisible'] ? 'Less than ${user.distanceBW} KM away' : 'Distance not visible' : 'Less than ${user.distanceBW} KM away'}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  user.editInfo['about'] != null
                      ? Text(
                          "${user.editInfo['about']}",
                          style: TextStyle(
                              color: secondryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  user.editInfo['about'] != null ? Divider() : Container(),
                  InkWell(
                    onTap: () => showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => ReportUser(
                              currentUser: currentUser,
                              seconduser: user,
                            )),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "REPORT ${user.name}".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: secondryColor),
                          ),
                        )),
                  ),
                  Divider(),
                  Padding(
                    child: Text(
                      "Partner Basic Info",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                    padding: EdgeInsets.only(top: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  user.ageRange['min'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.person, color: primaryColor),
                          title: Text(
                            "Age: ${user.ageRange['min']} to ${user.ageRange['max']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  user.editInfo['marital_status_p'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.insert_drive_file,
                              color: primaryColor),
                          title: Text(
                            "Marital Status: ${user.editInfo['marital_status_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  user.editInfo['height_p'] != null
                      ? ListTile(
                          dense: true,
                          leading:
                              Icon(Icons.arrow_circle_up, color: primaryColor),
                          title: Text(
                            "Height: ${user.editInfo['height_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  user.editInfo['religion_p'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.stars, color: primaryColor),
                          title: Text(
                            "Religion: ${user.editInfo['religion_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  user.editInfo['tongue_p'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.language, color: primaryColor),
                          title: Text(
                            "Mother Tongue: ${user.editInfo['tongue_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  Divider(),
                  Padding(
                    child: Text(
                      "Partner Location Details",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                    padding: EdgeInsets.only(top: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  user.editInfo['country_p'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.home, color: primaryColor),
                          title: Text(
                            "Country living in: ${user.editInfo['country_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  user.editInfo['state_p'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.home, color: primaryColor),
                          title: Text(
                            "State living in: ${user.editInfo['state_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  user.editInfo['city_p'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.home, color: primaryColor),
                          title: Text(
                            "City living in: ${user.editInfo['city_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  Divider(),
                  Padding(
                    child: Text(
                      "Partner Education & Career",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                    padding: EdgeInsets.only(top: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  user.editInfo['qualification_p'] != null
                      ? ListTile(
                          dense: true,
                          leading:
                              Icon(Icons.card_membership, color: primaryColor),
                          title: Text(
                            "Qualification: ${user.editInfo['qualification_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  user.editInfo['job_p'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.work, color: primaryColor),
                          title: Text(
                            "Job: ${user.editInfo['job_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  user.editInfo['profession_p'] != null
                      ? ListTile(
                          dense: true,
                          leading: Icon(Icons.badge, color: primaryColor),
                          title: Text(
                            "Profession: ${user.editInfo['profession_p']}",
                            style: TextStyle(
                                color: secondryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(),
                  Divider(),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.centerRight,
                child:
                matched
                    ?
                // FloatingActionButton(
                //     heroTag: UniqueKey(),
                //     backgroundColor: Colors.white,
                //     child: Icon(
                //       Icons.clear,
                //       color: Colors.red,
                //       size: 30,
                //     ),
                //     onPressed: () async {
                //       CollectionReference docRef =
                //       FirebaseFirestore.instance.collection("Users");
                //
                //         await docRef
                //             .doc(currentUser.id)
                //             .collection("CheckedUser")
                //             .doc(user.id)
                //             .set(
                //           {
                //             'DislikedUser':
                //             user.id,
                //             'timestamp': DateTime.now(),
                //           },
                //         );
                //
                //
                //
                //     })
                Text("")
                    :
                FloatingActionButton(
                    heroTag: UniqueKey(),
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.lightBlueAccent,
                      size: 30,
                    ),
                    onPressed: () async {
                      // Navigator.pop(context);
                      // swipeKey.currentState.swipeRight();
                      // Likedby();
                      CollectionReference docRef =
                      FirebaseFirestore.instance.collection("Users");
                      if (likedByList
                          .contains(user.id)) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              Future.delayed(
                                  Duration(milliseconds: 1700),
                                      () {
                                    Navigator.pop(ctx);
                                  });
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 80),
                                child: Align(
                                  alignment:
                                  Alignment.topCenter,
                                  child: Card(
                                    child: Container(
                                      height: 100,
                                      width: 300,
                                      child: Center(
                                        child: Text(
                                          "It's a match\n With ${user.name}",
                                          textAlign:
                                          TextAlign.center,
                                          style: TextStyle(
                                              color:
                                              primaryColor,
                                              fontSize: 30,
                                              decoration:
                                              TextDecoration
                                                  .none),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                        await docRef
                            .doc(currentUser.id)
                            .collection("Matches")
                            .doc(user.id)
                            .set(
                          {
                            'Matches': user.id,
                            'isRead': false,
                            'userName':
                            user.name,
                            'pictureUrl':
                            user.imageUrl[0],
                            'timestamp':
                            FieldValue.serverTimestamp()
                          },
                        );
                        await docRef
                            .doc(user.id)
                            .collection("Matches")
                            .doc(currentUser.id)
                            .set(
                          {
                            'Matches': currentUser.id,
                            'userName': currentUser.name,
                            'pictureUrl':
                            currentUser.imageUrl[0],
                            'isRead': false,
                            'timestamp':
                            FieldValue.serverTimestamp()
                          },
                        );
                      }

                      await docRef
                          .doc(currentUser.id)
                          .collection("CheckedUser")
                          .doc(user.id)
                          .set(
                        {
                          'LikedUser': user.id,
                          'timestamp':
                          FieldValue.serverTimestamp(),
                        },
                      );
                      await docRef
                          .doc(user.id)
                          .collection("LikedBy")
                          .doc(currentUser.id)
                          .set(
                        {
                          'LikedBy': currentUser.id,
                          'isRead': false,
                          'userName':
                          currentUser.name,
                          'pictureUrl':
                          currentUser.imageUrl[0],
                          'timestamp':
                          FieldValue.serverTimestamp()
                        },
                      );
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            Future.delayed(
                                Duration(milliseconds: 1700),
                                    () {
                                  Navigator.pop(ctx);
                                });
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 80),
                              child: Align(
                                alignment:
                                Alignment.topCenter,
                                child: Card(
                                  child: Container(
                                    height: 100,
                                    width: 300,
                                    child: Center(
                                      child: Text(
                                        "${user.name} is added in your liked list",
                                        textAlign:
                                        TextAlign.center,
                                        style: TextStyle(
                                            color:
                                            primaryColor,
                                            fontSize: 30,
                                            decoration:
                                            TextDecoration
                                                .none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });

                    }),

              ),
            ),

                 isMe
                ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: primaryColor,
                            ),
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => EditProfile(user))))),
                  )
                : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message,
                              color: primaryColor,
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ChatPage(
                                          sender: currentUser,
                                          second: user,
                                          chatId: chatId(user, currentUser),
                                        ))))),
                  )
          ],
        ),
      ),
    );
  }
}

void Likedby() {

}

class VideoWidget extends StatefulWidget {
  final bool play;
  final String url;

  const VideoWidget({Key key, @required this.url, @required this.play})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = new VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return new Container(
            child: Card(
              key: new PageStorageKey(widget.url),
              elevation: 5.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    //padding: const EdgeInsets.all(8.0),
                    child: Chewie(
                      key: new PageStorageKey(widget.url),
                      controller: ChewieController(
                        videoPlayerController: videoPlayerController,
                        aspectRatio: 3 / 2,
                        autoInitialize: true,
                        looping: false,
                        autoPlay: false,
                        // Errors can occur for example when trying to play a video
                        // from a non-existent URL
                        errorBuilder: (context, errorMessage) {
                          return Center(
                            child: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
