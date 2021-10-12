import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matriapp/Screens/UserDOB.dart';
import 'package:matriapp/Screens/UserName.dart';
import 'package:matriapp/util/color.dart';

class Works extends StatefulWidget {
  @override
  _WorksState createState() => _WorksState();
}

class _WorksState extends State<Works> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              // FittedBox(
              //   child: Image.asset('asset/how-app-works.jpg'),
              //   fit: BoxFit.fill,
              // ),
              Image.asset(
                "asset/how-app-works.jpg",
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  // height: MediaQuery.of(context).size.height * .8,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        SizedBox(
                          height: 20,
                        ),


                        // Text(
                        //   "How App Works",
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //       fontSize: 35,
                        //       color: primaryColor,
                        //       fontWeight: FontWeight.bold,
                        //       fontStyle: FontStyle.normal),
                        // ),

                        ListTile(
                          contentPadding: EdgeInsets.all(8),

                          title: Text(
                            "Paid Spouse is the world's First Marriage Support  Match Making Service that provides services for better future with marriage. World's First and Most successful Matrimonial App that is trusted by millions of peoples of Africa and Asia in finding their soul mates. Millions of Peoples find their soul mate through the paid spouse and living a happy life.\n Paid Spouse Support Marriage is the world's First App that provides a platform for youngsters to get bright future and marriage at one place. You can make house son in law offers.  A platform for the marriage of Jobless, homeless, divorced people.  A passion for service. You can make offers/demands of what all you have.",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),



                      ],
                    ),

                ),
              ),

            ],
          ),
        ));
  }
}
