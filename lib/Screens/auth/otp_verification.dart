import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matriapp/Screens/Tab.dart';
import 'package:matriapp/Screens/auth/otp.dart';
import 'package:matriapp/util/color.dart';
import 'package:matriapp/util/snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'login.dart';

class Verification extends StatefulWidget {
  final bool updateNumber;
  final String phoneNumber;
  final String smsVerificationCode;
  Verification(this.phoneNumber, this.smsVerificationCode, this.updateNumber);

  @override
  _VerificationState createState() => _VerificationState();
}

var onTapRecognizer;

class _VerificationState extends State<Verification> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Login _login = new Login();
  Future updateNumber() async {
    User user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .set({'phoneNumber': user.phoneNumber}, SetOptions(merge: true)).then((_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            Future.delayed(Duration(seconds: 2), () async {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Tabbar(null, null)));
            });
            return Center(
                child: Container(
                    width: 180.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: <Widget>[
                        // Image.asset(
                        //   "asset/auth/verified.jpg",
                        //   height: 100,
                        // ),
                        Text(
                          "Phone Number\nChanged\nSuccessfully",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 20),
                        )
                      ],
                    )));
          });
    });
  }

  String code;
  @override
  void initState() {
    super.initState();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 100),
                width: 300,
                // child: Image.asset(
                //   "asset/auth/verifyOtp.png",
                // ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
              child: RichText(
                text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                          text: widget.phoneNumber,
                          style: TextStyle(
                              color: pinkColor,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: 15)),
                    ],
                    style: TextStyle(color: Colors.black54, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: true,
                obscuringCharacter: '*',
                obscuringWidget: FlutterLogo(
                  size: 24,
                ),
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,

                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                ),
                cursorColor: Colors.black,
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,

                keyboardType: TextInputType.number,
                boxShadows: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onChanged: (value) {
                  code = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Didn't receive the code? ",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                  children: [
                    TextSpan(
                        text: " RESEND",
                        recognizer: onTapRecognizer,
                        style: TextStyle(
                            color: Color(0xFF91D3B3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16))
                  ]),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(colors: [pinkColor, appColor])),
                  height: MediaQuery.of(context).size.height * .065,
                  width: MediaQuery.of(context).size.width * .75,
                  child: Center(
                      child: Text(
                    "VERIFY",
                    style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.bold),
                  ))),
              onTap: () async {
                showDialog(
                  builder: (context) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                    return Center(
                        child: CupertinoActivityIndicator(
                      radius: 20,
                    ));
                  },
                  barrierDismissible: false,
                  context: context,
                );
                AuthCredential _phoneAuth = PhoneAuthProvider.credential(
                    verificationId: widget.smsVerificationCode, smsCode: code);
                if (widget.updateNumber) {
                  User user = FirebaseAuth.instance.currentUser;
                  user
                      .updatePhoneNumber(_phoneAuth)
                      .then((_) => updateNumber())
                      .catchError((e) {
                    CustomSnackbar.snackbar("$e", _scaffoldKey);
                  });
                } else {
                  FirebaseAuth.instance
                      .signInWithCredential(_phoneAuth)
                      .then((UserCredentail) {
                    if (UserCredentail != null) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            Future.delayed(Duration(seconds: 2), () async {
                              Navigator.pop(context);
                              await _login.navigationCheck(
                                  UserCredentail.user, context);
                            });
                            return Center(
                                child: Container(
                                    width: 180.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: <Widget>[
                                        // Image.asset(
                                        //   "asset/auth/verified.jpg",
                                        //   height: 100,
                                        // ),
                                        Text(
                                          "Verified\n Successfully",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Colors.black,
                                              fontSize: 20),
                                        )
                                      ],
                                    )));
                          });
                      FirebaseFirestore.instance
                          .collection('Users')
                          .where('userId', isEqualTo: UserCredentail.user.uid)
                          .get()
                          .then((QuerySnapshot snapshot) async {
                        if (snapshot.docs.length <= 0) {
                          await setDataUser(UserCredentail.user);
                        }
                      });
                    }
                  }).catchError((onError) {
                    CustomSnackbar.snackbar("$onError", _scaffoldKey);
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
