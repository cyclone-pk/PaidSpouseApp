import 'package:flutter/material.dart';
import 'package:matriapp/Screens/Chat/recent_chats.dart';
import 'package:matriapp/models/user_model.dart';
import 'package:matriapp/util/color.dart';
import 'Matches.dart';

class HomeScreen extends StatefulWidget {
  final Uuser currentUser;
  final List<Uuser> matches;
  final List<Uuser> allusers;
  HomeScreen(this.currentUser, this.matches, this.allusers);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (widget.matches.length > 0 ) {
        widget.matches.sort((a, b) {
          var adate = a.lastmsg; //before -> var adate = a.expiry;
          var bdate = b.lastmsg; //before -> var bdate = b.expiry;
          return bdate?.compareTo(
              adate); //to get the order other way just switch `adate & bdate`
        });
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: TextStyle(
            color: primaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: ClipRRect(
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Matches(widget.currentUser, widget.allusers),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Recent messages',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                RecentChats(widget.currentUser, widget.matches),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
