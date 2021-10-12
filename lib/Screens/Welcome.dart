import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matriapp/Screens/UserDOB.dart';
import 'package:matriapp/Screens/UserName.dart';
import 'package:matriapp/util/color.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          "PaidSpouse Matrimonial",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 35,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Welcome to Matrimonial app.\nPlease follow these House Rules.",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Be yourself.",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Make sure your photos, age, and bio are true to who you are.",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Play it cool.",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Respect others and treat them as you would like to be treated",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Stay safe.",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Don't be too quick to give out personal information.",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Be proactive.",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Always report bad behavior.",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient:
                                LinearGradient(colors: [pinkColor, appColor])),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                            child: Text(
                          "GOT IT",
                          style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      User _user= FirebaseAuth.instance.currentUser;

                        if (_user.displayName != null) {
                          if (_user.displayName.length > 0) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UserDOB(
                                        {'UserName': _user.displayName})));
                          } else {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UserName()));
                          }
                        } else {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => UserName()));
                        }

                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
