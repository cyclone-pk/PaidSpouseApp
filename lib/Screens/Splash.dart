import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,

        body: Center(
      child: Container(
          // height: 132,
          // width: 240,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         fit: BoxFit.fill, image: AssetImage("asset/login.jpg")),
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          //     color: Colors.white),

          // child: Image.asset(
          //   "asset/matriapp-Logo-BP.png",
          //   fit: BoxFit.contain,
          // )
          ),
    ));
  }
}
