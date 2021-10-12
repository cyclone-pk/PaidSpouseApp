import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matriapp/Screens/Profile/profile.dart';
import 'package:matriapp/Screens/Splash.dart';
import 'package:matriapp/Screens/blockUserByAdmin.dart';
import 'package:matriapp/Screens/notifications.dart';
import 'package:matriapp/Screens/Home_page.dart';
import 'package:matriapp/models/user_model.dart';
import 'package:matriapp/Screens/Profile/filters.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Calling/incomingCall.dart';
import 'Chat/home_screen.dart';
import 'Home.dart';
import 'package:matriapp/util/color.dart';

List likedByList = [];
List matchedByList = [];

class Tabbar extends StatefulWidget {
  final bool isPaymentSuccess;
  final String plan;

  Tabbar(this.plan, this.isPaymentSuccess);
  @override
  TabbarState createState() => TabbarState();
}

//_
class TabbarState extends State<Tabbar> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  CollectionReference docRef = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Uuser currentUser;
  List<Uuser> matches = [];
  List<Uuser> newmatches = [];

  List<Uuser> users = [];
  List<Uuser> usersAll = [];
  int mcount=0;

  /// Past purchases
  List<PurchaseDetails> purchases = [];
  InAppPurchase _iap = InAppPurchase.instance;
  bool isPuchased = false;
  @override
  void initState() {
    super.initState();
    // Show payment success alert.
    if (widget.isPaymentSuccess != null && widget.isPaymentSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.success,
          title: "Confirmation",
          desc: "You have successfully subscribed to our ${widget.plan} plan.",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
    _getAccessItems();
    _getCurrentUser();
    _getMatches();
   // _getpastPurchases();

  }

  Map items = {};
  _getAccessItems() async {
    FirebaseFirestore.instance.collection("Item_access").snapshots().listen((doc) {
      if (doc.docs.length > 0) {
        items = doc.docs[0].data();
        print(doc.docs[0].data);
      }

      if (mounted) setState(() {});
    });
  }

   _getMessagesCount(String sid) async {
    FirebaseFirestore.instance.collection("chats")
        //.where("chats", arrayContains: currentUser.id)
        .doc(chatsId(currentUser.id, sid))
      // .doc(currentUser.id)
        .collection('messages')
        .where("type", isEqualTo: "Msg")
         .where("receiver_id", isEqualTo: currentUser.id)
         .where("isRead", isEqualTo: false)
    .snapshots().listen((doc) {
      // if (doc.docs.length > 0) {
      //   items = doc.docs[0].data;
      //   print(doc.docs[0].data);
      // }
      print(doc.docs.length);
      mcount+= doc.docs.length;

      if (mounted) setState(() {});
    });
  }

  // Future<void> _getpastPurchases() async {
  //   print('in past purchases');
  //   QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
  //   print('response   ${response.pastPurchases}');
  //   for (PurchaseDetails purchase in response.pastPurchases) {
  //     // if (Platform.isIOS) {
  //     await _iap.completePurchase(purchase);
  //     // }
  //   }
  //   setState(() {
  //     purchases = response.pastPurchases;
  //   });
  //   if (response.pastPurchases.length > 0) {
  //     purchases.forEach((purchase) async {
  //       print('   ${purchase.productID}');
  //       await _verifyPuchase(purchase.productID);
  //     });
  //   }
  // }

  /// check if user has pruchased
  PurchaseDetails _hasPurchased(String productId) {
    return purchases.firstWhere((purchase) => purchase.productID == productId,
        orElse: () => null);
  }

  ///verifying pourchase of user
  Future<void> _verifyPuchase(String id) async {
    PurchaseDetails purchase = _hasPurchased(id);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      print(purchase.productID);
      if (Platform.isIOS) {
        await _iap.completePurchase(purchase);
        print('Achats antérieurs........$purchase');
        isPuchased = true;
      }
      isPuchased = true;
    } else {
      isPuchased = false;
    }
  }

  int swipecount = 0;
  _getSwipedcount() {
    FirebaseFirestore.instance
        .collection('/Users/${currentUser.id}/CheckedUser')
        .where(
          'timestamp',
          isGreaterThan: Timestamp.now().toDate().subtract(Duration(days: 1)),
        )
        .snapshots()
        .listen((event) {
      print(event.docs.length);
      setState(() {
        swipecount = event.docs.length;
      });
      return event.docs.length;
    });
  }

  configurePushNotification(Uuser user) async {

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );



    _firebaseMessaging.getToken().then((token) {
      print(token);
      docRef.doc(user.id).update({
        'pushToken': token,
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

        print('===============onLaunch$message');
        if (Platform.isIOS && message.data['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message.data['channel_id'];
          callInfo['senderName'] = message.data['senderName'];
          callInfo['senderPicture'] = message.data['senderPicture'];
          bool iscallling = _checkcallState(message.data['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Incoming(message)));
          }
        } else if (Platform.isAndroid && message.data['type'] == 'Call') {
          bool iscallling =
              _checkcallState(message.data['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Incoming(message.data)));
          } else {
            print("Timeout");
          }
        }


        print("onmessage$message");
        if (Platform.isIOS && message.data['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message.data['channel_id'];
          callInfo['senderName'] = message.data['senderName'];
          callInfo['senderPicture'] = message.data['senderPicture'];
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Incoming(callInfo)));
        } else if (Platform.isAndroid && message.data['type'] == 'Call') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Incoming(message.data)));
        } else
          print("object");


        print('onResume$message');
        if (Platform.isIOS && message.data['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message.data['channel_id'];
          callInfo['senderName'] = message.data['senderName'];
          callInfo['senderPicture'] = message.data['senderPicture'];
          bool iscallling = _checkcallState(message.data['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Incoming(message)));
          }
        } else if (Platform.isAndroid && message.data['type'] == 'Call') {
          bool iscallling =
              _checkcallState(message.data['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Incoming(message.data['data'])));
          } else {
            print("Timeout");
          }
        }

  });
  }

  _checkcallState(channelId) async {
    bool iscalling = await FirebaseFirestore.instance
        .collection("calls")
        .doc(channelId)
        .get()
        .then((value) {
      return value["calling"] ?? false;
    });
    return iscalling;
  }

  _getMatches() async {
    User user = _firebaseAuth.currentUser;
    return FirebaseFirestore.instance
        .collection('/Users/${user.uid}/Matches')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((ondata) {
      matches.clear();
      newmatches.clear();
      matchedByList.clear();
      if (ondata.docs.length > 0) {
        ondata.docs.forEach((f) async {
          DocumentSnapshot doc = await docRef.doc(f['Matches']).get();
          if (doc.exists) {
            Uuser tempuser = Uuser.fromMap(doc.data());
            tempuser.distanceBW = calculateDistance(
                    currentUser.coordinates['latitude'],
                    currentUser.coordinates['longitude'],
                    tempuser.coordinates['latitude'],
                    tempuser.coordinates['longitude'])
                .round();

            matches.add(tempuser);
            matchedByList.add(tempuser.id);
            newmatches.add(tempuser);
            if (mounted) setState(() {});
          }
        });
      }
    });
  }

  _getCurrentUser() async {
    User user = await _firebaseAuth.currentUser;
    return docRef.doc("${user.uid}").snapshots().listen((data) async {
      currentUser = Uuser.fromMap(data.data());
      if (mounted) setState(() {});
      users.clear();
      usersAll.clear();
      likedByList.clear();
      userRemoved.clear();
      getUserList();
      getUsersList();
      getLikedByList();
      configurePushNotification(currentUser);
      if (!isPuchased) {
        _getSwipedcount();
      }
      return currentUser;
    });
  }

  query() {
    if (currentUser.showGender == 'everyone') {
      return docRef
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(currentUser.ageRange['min']),
          )
          .where('age',
              isLessThanOrEqualTo: int.parse(currentUser.ageRange['max']))
          .orderBy('age', descending: false);
    } else {
      return docRef
          .where('editInfo.userGender', isEqualTo: currentUser.showGender)
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(currentUser.ageRange['min']),
          )
          .where('age',
              isLessThanOrEqualTo: int.parse(currentUser.ageRange['max']))
          //FOR FETCH USER WHO MATCH WITH USER SEXUAL ORIENTAION
          // .where('sexualOrientation.orientation',
          //     arrayContainsAny: currentUser.sexualOrientation)
          .orderBy('age', descending: false);
    }
  }

  queryy() {

      return docRef
      //     .where(
      //   'age',
      //   isGreaterThanOrEqualTo: int.parse(currentUser.ageRange['min']),
      // )
          // .where('age',
          // isLessThanOrEqualTo: int.parse(currentUser.ageRange['max']))
          .orderBy('visits', descending: true);

  }

  Future getUserList() async {
    List checkedUser = [];
    FirebaseFirestore.instance
        .collection('/Users/${currentUser.id}/CheckedUser')
        .get()
        .then((data) {
      checkedUser.addAll(data.docs.map((f) => f['DislikedUser']));
      checkedUser.addAll(data.docs.map((f) => f['LikedUser']));
    }).then((_) {
      query().get().then((data) async {
        if (data.docs.length < 1) {
          print("no more data");
          return;
        }
        users.clear();
        userRemoved.clear();
        for (var doc in data.docs) {
          Uuser temp = Uuser.fromMap(doc);
          var distance = calculateDistance(
              currentUser.coordinates['latitude'],
              currentUser.coordinates['longitude'],
              temp.coordinates['latitude'],
              temp.coordinates['longitude']);
          temp.distanceBW = distance.round();
          if (checkedUser.any(
            (value) => value == temp.id,
          )) {
          } else {
            if (distance <= currentUser.maxDistance &&
                temp.id != currentUser.id &&
                !temp.isBlocked) {
              users.add(temp);
            }
          }
        }
        if (mounted) setState(() {});
      });
    });
  }

  Future getUsersList() async {
    List checkedUser = [];
    FirebaseFirestore.instance
        .collection('/Users/${currentUser.id}/CheckedUser')
        .get()
        .then((data) {
     // checkedUser.addAll(data.docs.map((f) => f['DislikedUser']));
      //checkedUser.addAll(data.docs.map((f) => f['LikedUser']));
    }).then((_) {
      queryy().get().then((data) async {
        if (data.docs.length < 1) {
          print("no more data users");
          return;
        }
        usersAll.clear();
        mcount=0;
        //userRemoved.clear();
        for (var doc in data.docs) {
          Uuser temp = Uuser.fromMap(doc.data());
          var distance = calculateDistance(
              currentUser.coordinates['latitude'],
              currentUser.coordinates['longitude'],
              temp.coordinates['latitude'],
              temp.coordinates['longitude']);
          temp.distanceBW = distance.round();

            if (distance <= currentUser.maxDistance &&
                temp.id != currentUser.id ) {
              usersAll.add(temp);
              _getMessagesCount(temp.id);
            }

        }
        if (mounted) setState(() {});
      });
    });
  }

  getLikedByList() {
    docRef
        .doc(currentUser.id)
        .collection("LikedBy")
        .snapshots()
        .listen((data) async {
      likedByList.addAll(data.docs.map((f) => f['LikedBy']));
    });
  }

  // getMatchedByList() {
  //   matchedByList.clear();
  //   docRef
  //       .doc(currentUser.id)
  //       .collection("Matches")
  //       .snapshots()
  //       .listen((data) async {
  //     matchedByList.addAll(data.docs.map((f) => f['Matches']));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                FlatButton(
                  onPressed: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        body: currentUser == null
            ? Center(child: Splash())
            : currentUser.isBlocked
            ? BlockUser()
            : DefaultTabController(
                length: 5,
                initialIndex: widget.isPaymentSuccess != null
                    ? widget.isPaymentSuccess
                        ? 0
                        : 1
                    : 1,
                child: Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [pinkColor, appColor]))),
                      automaticallyImplyLeading: false,
                      title: new Text('PaidSpouse'),
                      actions: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      maintainState: true,
                                      builder: (context) => Filters(
                                          currentUser, isPuchased, items))),
                              child: Icon(
                                Icons.search,
                                size: 26.0,
                              ),
                            )),
                      ],
                    ),
                    bottomNavigationBar: Container(
                      //  color: primaryColor,
                      decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [pinkColor, appColor])),
                      child: TabBar(
                          labelColor: Colors.white,
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.person,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.home,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.whatshot,
                              ),
                            ),
                            likedByList.length > 0 ?
                            Tab(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(Icons.notifications),
                                  new Positioned(
                                    right: 0,

                                    child: new Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                      child: new Text(
                                        '${likedByList.length}',
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                                :
                            Tab(
                              icon: Icon(
                                Icons.notifications,
                              ),
                            ),
                            mcount > 0 ?
                            Tab(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(Icons.message),
                                  new Positioned(
                                    right: 0,

                                    child: new Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                      child: new Text(
                                        '${mcount}',
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                                :
                            Tab(
                              icon: Icon(
                                Icons.message,
                              ),
                            ),
                          ]),
                    ),
                    body: TabBarView(
                      children: [
                        Center(
                            child: Profile(
                                currentUser, isPuchased, purchases, items)),
                        Center(child: HomePage(currentUser, users, usersAll)),
                        Center(
                            child: CardPictures(
                                currentUser, users, swipecount, items)),
                        Center(child: Notifications(currentUser, newmatches)),
                        Center(
                            child:
                                HomeScreen(currentUser, usersAll, newmatches)),
                      ],
                      physics: NeverScrollableScrollPhysics(),
                    )),
              ),
      ),
    );
  }
}
var groupChatsId;
chatsId(currentUser, sender) {
  // if (currentUser.hashCode <= sender.hashCode) {
  //   return groupChatsId = '${currentUser}-${sender}';
  // } else {
  //   return groupChatsId = '${sender}-${currentUser}';
  // }
  return groupChatsId = '${sender}-${currentUser}';
  //return groupChatsId = '${currentUser}-${sender}';
}
double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
