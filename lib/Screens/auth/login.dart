import 'dart:io';
//import 'package:apple_sign_in/apple_sign_in.dart' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matriapp/Screens/Tab.dart';
import 'package:matriapp/Screens/Welcome.dart';
import 'package:matriapp/Screens/auth/otp.dart';
//import 'package:matriapp/models/custom_web_view.dart';
import 'package:matriapp/util/color.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  static const your_client_id = '398917791321810';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const your_redirect_url =
      'https://matrimonialapp-2bb60.firebaseapp.com/__/auth/handler';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   elevation: 0,
        //   flexibleSpace: Container(
        //       decoration: BoxDecoration(
        //           gradient: LinearGradient(
        //               colors: [pinkColor, primaryColor.withOpacity(.5)]))),
        // ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Colors.white),
          child: ListView(
            children: <Widget>[
              Column(children: <Widget>[
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * .1,
                // ),
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: WaveClipper2(),
                      child: Container(
                        child: Column(),
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          darkPrimaryColor,
                          primaryColor.withOpacity(.15)
                        ])),
                      ),
                    ),
                    ClipPath(
                      clipper: WaveClipper3(),
                      child: Container(
                        child: Column(),
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          darkPrimaryColor,
                          primaryColor.withOpacity(.2)
                        ])),
                      ),
                    ),
                    ClipPath(
                      clipper: WaveClipper1(),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Image.asset(
                              "asset/matriapp-Logo-BW.png",
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: [pinkColor, appColor])),
                      ),
                    ),
                  ],
                ),

                Container(
                  child: Text(
                    """By tapping "Log in", you agree with our
Terms.Learn how we process your data in
our Privacy Policy and Cookies Policy.""",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10, bottom: 10),
                //   child: Material(
                //     elevation: 2.0,
                //     borderRadius: BorderRadius.all(Radius.circular(30)),
                //     child: Padding(
                //       padding: const EdgeInsets.all(6.0),
                //       child: InkWell(
                //         child: Container(
                //             decoration: BoxDecoration(
                //                 shape: BoxShape.rectangle,
                //                 borderRadius: BorderRadius.circular(25),
                //                 gradient: LinearGradient(
                //                     begin: Alignment.topRight,
                //                     end: Alignment.bottomLeft,
                //                     colors: [
                //                       blueColor.withOpacity(.5),
                //                       blueColor.withOpacity(.8),
                //                       blueColor,
                //                       blueColor
                //                     ])),
                //             height: MediaQuery.of(context).size.height * .065,
                //             width: MediaQuery.of(context).size.width * .8,
                //             child: Center(
                //                 child: Text(
                //               "LOG IN WITH FACEBOOK",
                //               style: TextStyle(
                //                   color: textColor,
                //                   fontWeight: FontWeight.bold),
                //             ))),
                //         onTap: () async {
                //           showDialog(
                //               context: context,
                //               child: Container(
                //                   height: 30,
                //                   width: 30,
                //                   child: Center(
                //                       child: CupertinoActivityIndicator(
                //                     key: UniqueKey(),
                //                     radius: 20,
                //                     animating: true,
                //                   ))));
                //           await handleFacebookLogin(context).then((user) {
                //             navigationCheck(user, context);
                //           }).then((_) {
                //             Navigator.pop(context);
                //           }).catchError((e) {
                //             Navigator.pop(context);
                //           });
                //         },
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10, bottom: 10),
                //   child: Material(
                //     elevation: 2.0,
                //     borderRadius: BorderRadius.all(Radius.circular(30)),
                //     child: Padding(
                //       padding: const EdgeInsets.all(6.0),
                //       child: InkWell(
                //         child: Container(
                //             decoration: BoxDecoration(
                //                 shape: BoxShape.rectangle,
                //                 borderRadius: BorderRadius.circular(25),
                //                 gradient: LinearGradient(
                //                     begin: Alignment.topRight,
                //                     end: Alignment.bottomLeft,
                //                     colors: [
                //                       primaryColor.withOpacity(.5),
                //                       primaryColor.withOpacity(.8),
                //                       primaryColor,
                //                       primaryColor
                //                     ])),
                //             height: MediaQuery.of(context).size.height * .065,
                //             width: MediaQuery.of(context).size.width * .8,
                //             child: Center(
                //                 child: Text(
                //               "LOG IN WITH FACEBOOK",
                //               style: TextStyle(
                //                   color: textColor,
                //                   fontWeight: FontWeight.bold),
                //             ))),
                //         onTap: () async {
                //           // showDialog(
                //           //     context: context,
                //           //     child: Container(
                //           //         height: 30,
                //           //         width: 30,
                //           //         child: Center(
                //           //             child: CupertinoActivityIndicator(
                //           //           key: UniqueKey(),
                //           //           radius: 20,
                //           //           animating: true,
                //           //         ))));
                //           await handleFacebookLogin(context).then((user) {
                //             navigationCheck(user, context);
                //           }).then((_) {
                //             Navigator.pop(context);
                //           }).catchError((e) {
                //             Navigator.pop(context);
                //           });
                //         },
                //       ),
                //     ),
                //   ),
                // ),

                OutlineButton(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text("LOG IN WITH PHONE NUMBER",
                            style: TextStyle(
                                color: pinkColor,
                                fontWeight: FontWeight.bold))),
                  ),
                  borderSide: BorderSide(
                      width: 1, style: BorderStyle.solid, color: pinkColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: () {
                    bool updateNumber = false;
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => OTP(updateNumber)));
                  },
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Trouble logging in?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => _launchURL(
                        "http://www.paidspouse.com/privacy_policy.html"), //TODO: add privacy policy
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white),
                  ),
                  GestureDetector(
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => _launchURL(
                        "http://www.paidspouse.com/Terms-Service.html"), //TODO: add Terms and conditions
                  ),
                ],
              )
            ],
          ),
        ),
      ),
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
    );
  }

  Future<User> handleFacebookLogin(context) async {
    // Trigger the sign-in flow
    User user;
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);
   user = ( await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential)).user;
    // Once signed in, return the UserCredential
    return user;
  }


  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future navigationCheck(User currentUser, context) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('userId', isEqualTo: currentUser.uid)
        .get()
        .then((docs) async {
      if (docs.docs[0].exists) {
        if (docs.docs[0].data()['location'] != null) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => Tabbar(null, null)));
        } else {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Welcome()));
        }
      } else {
        await _setUser(currentUser);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Welcome()));
      }
    });
  }


}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Future _setUser(User user) async {
  await FirebaseFirestore.instance.collection("Users").doc(user.uid).set(
    {
      'userId': user.uid,
      'UserName': user.displayName ?? '',
      'Pictures': FieldValue.arrayUnion([
        user.photoURL ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxUC64VZctJ0un9UBnbUKtj-blhw02PeDEQIMOqovc215LWYKu&s'
      ]),
      'phoneNumber': user.phoneNumber,
      'timestamp': FieldValue.serverTimestamp()
    },
    SetOptions(merge: true),
  );
}
