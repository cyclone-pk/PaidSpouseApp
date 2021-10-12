import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matriapp/Screens/Splash.dart';
import 'package:matriapp/Screens/Tab.dart';
import 'package:matriapp/Screens/Welcome.dart';
import 'package:matriapp/Screens/auth/login.dart';
import 'package:matriapp/ads/ads.dart';
import 'package:matriapp/util/color.dart';
//import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) {
    if (Platform.isAndroid) {
      // For play billing library 2.0 on Android, it is mandatory to call
      // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
      // as part of initializing the app.
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
    runApp(new MyApp());
  });
  //runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isAuth = false;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();

    _checkAuth();
    FirebaseAdMob.instance
        .initialize(appId: Platform.isAndroid ? androidAdAppId : iosAdAppId);
  }

  Future _checkAuth() async {
    final User user = FirebaseAuth.instance.currentUser;
    //if (user == null) {
      //print(user);
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .where('userId', isEqualTo: user.uid)
            .get()
            .then((docs) async {
          if (docs.docs[0].exists) {
            if (docs.docs[0].data()['location'] != null) {
              setState(() {
                isRegistered = true;
                isLoading = false;
              });
            } else {
              setState(() {
                isAuth = true;
                isLoading = false;
              });
            }
            print("loggedin ${user.uid}");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: isLoading
          ? Splash()
          : isRegistered
          ? Tabbar(null, null)
          : isAuth
          ? Welcome()
          : Login(),
    );
  }
}
