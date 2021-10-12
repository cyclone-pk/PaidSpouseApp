import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matriapp/Screens/Chat/largeImage.dart';
import 'package:matriapp/Screens/Information.dart';
import 'package:matriapp/Screens/reportUser.dart';
import 'package:matriapp/ads/ads.dart';
import 'package:matriapp/models/user_model.dart';
import 'package:matriapp/util/color.dart';
import 'package:matriapp/util/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Calling/dial.dart';

class ChatPage extends StatefulWidget {
  final Uuser sender;
  final String chatId;
  final Uuser second;
  ChatPage({this.sender, this.chatId, this.second});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isBlocked = false;
  final db = FirebaseFirestore.instance;
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Ads _ads = new Ads();

  @override
  void initState() {
    _ads.myInterstitial()
      ..load()
      ..show();
    print("object    -${widget.chatId}");
    super.initState();
    chatReference =
        db.collection("chats").doc(widget.chatId).collection('messages');
    checkblock();
  }

  var blockedBy;
  checkblock() {
    chatReference.doc('blocked').get().then((onData) {
      if (onData.exists) {
        blockedBy = onData['blockedBy'];
        if (onData['isBlocked']) {
          isBlocked = true;
        } else {
          isBlocked = false;
        }

        if (mounted) setState(() {});
      }
      // print(onData.data['blockedBy']);
    });
  }

  List<Widget> generateSenderLayout(docs) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              child: docs['image_url'] != ''
                  ? InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(
                                top: 2.0, bottom: 2.0, right: 15),
                            child: Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 10,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  height:
                                      MediaQuery.of(context).size.height * .65,
                                  width: MediaQuery.of(context).size.width * .9,
                                  imageUrl:
                                      docs['image_url'] ?? '',
                                  fit: BoxFit.fitWidth,
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child:
                                      docs['isRead'] == false
                                          ? Icon(
                                              Icons.done,
                                              color: secondryColor,
                                              size: 15,
                                            )
                                          : Icon(
                                              Icons.done_all,
                                              color: primaryColor,
                                              size: 15,
                                            ),
                                )
                              ],
                            ),
                            height: 150,
                            width: 150.0,
                            color: Colors.white.withOpacity(.5),
                            padding: EdgeInsets.all(5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                                docs["time"] != null
                                    ? DateFormat.yMMMd()
                                        .add_jm()
                                        .format(docs["time"]
                                            .toDate())
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                )),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => LargeImage(
                              docs['image_url'],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      margin: EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 8.0, right: 10),
                      decoration: BoxDecoration(
                          color: textColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Text(
                                    docs['text'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                docs["time"] != null
                                    ? DateFormat.MMMd()
                                        .add_jm()
                                        .format(docs["time"]
                                            .toDate())
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              docs['isRead'] == false
                                  ? Icon(
                                      Icons.done,
                                      color: secondryColor,
                                      size: 15,
                                    )
                                  : Icon(
                                      Icons.done_all,
                                      color: primaryColor,
                                      size: 15,
                                    )
                            ],
                          ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    ];
  }

  _messagesIsRead(documentSnapshot) {
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: CircleAvatar(
              backgroundColor: secondryColor,
              radius: 25.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: CachedNetworkImage(
                  imageUrl: widget.second.imageUrl[0] ?? '',
                  useOldImageOnUrlChange: true,
                  placeholder: (context, url) => CupertinoActivityIndicator(
                    radius: 15,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            onTap: () => showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return Info(widget.second, widget.sender, null);
                }),
          ),
        ],
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: documentSnapshot['image_url'] != ''
                  ? InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(
                                top: 2.0, bottom: 2.0, right: 15),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child: CupertinoActivityIndicator(
                                  radius: 10,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              height: MediaQuery.of(context).size.height * .65,
                              width: MediaQuery.of(context).size.width * .9,
                              imageUrl:
                                  documentSnapshot['image_url'] ?? '',
                              fit: BoxFit.fitWidth,
                            ),
                            height: 150,
                            width: 150.0,
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            padding: EdgeInsets.all(5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                                documentSnapshot["time"] != null
                                    ? DateFormat.yMMMd()
                                        .add_jm()
                                        .format(documentSnapshot["time"]
                                            .toDate())
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                )),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => LargeImage(
                            documentSnapshot['image_url'],
                          ),
                        ));
                      },
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.lightGreenAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Text(
                                    documentSnapshot['text'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                documentSnapshot["time"] != null
                                    ? DateFormat.MMMd()
                                        .add_jm()
                                        .format(documentSnapshot["time"]
                                            .toDate())
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> generateReceiverLayout(docs) {
    if (!docs['isRead']) {
      chatReference.doc(docs.documentID).update({
        'isRead': true,
      });

      return _messagesIsRead(docs);
    }
    return _messagesIsRead(docs);
  }

  generateMessages(docs) {
    return docs
        .map<Widget>((doc) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: doc['type'] == "Call"
                      ? [
                          Text(doc["time"] != null
                              ? "${doc['text']} : " +
                                  DateFormat.yMMMd()
                                      .add_jm()
                                      .format(doc["time"].toDate())
                                      .toString() +
                                  " by ${doc['sender_id'] == widget.sender.id ? "You" : "${widget.second.name}"}"
                              : "")
                        ]
                      : doc['sender_id'] != widget.sender.id
                      ? generateReceiverLayout(
                          doc,
                        )
                      : generateSenderLayout(doc)),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [pinkColor, appColor]))),
          title: Text(widget.second.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
               // icon: Icon(Icons.call), onPressed: () => onJoin("AudioCall")),
                icon: Icon(Icons.call), onPressed: () => launch("tel://"+widget.second.phoneNumber)),
            // IconButton(
            //     icon: Icon(Icons.video_call),
            //     onPressed: () => onJoin("VideoCall")),
            PopupMenuButton(itemBuilder: (ct) {
              return [
                PopupMenuItem(
                  value: 'value1',
                  child: InkWell(
                    onTap: () => showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => ReportUser(
                              currentUser: widget.sender,
                              seconduser: widget.second,
                            )).then((value) => Navigator.pop(ct)),
                    child: Container(
                        width: 100,
                        height: 30,
                        child: Text(
                          "Report",
                        )),
                  ),
                ),
                PopupMenuItem(
                  height: 30,
                  value: 'value2',
                  child: InkWell(
                    child: Text(isBlocked ? "Unblock user" : "Block user"),
                    onTap: () {
                      Navigator.pop(ct);
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: Text(isBlocked ? 'Unblock' : 'Block'),
                            content: Text(
                                'Do you want to ${isBlocked ? 'Unblock' : 'Block'} ${widget.second.name}?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('No'),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  Navigator.pop(ctx);
                                  if (isBlocked &&
                                      blockedBy == widget.sender.id) {
                                    chatReference.doc('blocked').set({
                                      'isBlocked': !isBlocked,
                                      'blockedBy': widget.sender.id,
                                    });
                                  } else if (!isBlocked) {
                                    chatReference.doc('blocked').set({
                                      'isBlocked': !isBlocked,
                                      'blockedBy': widget.sender.id,
                                    });
                                  } else {
                                    CustomSnackbar.snackbar(
                                        "You can't unblock", _scaffoldKey);
                                  }
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              ];
            })
          ]),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          //backgroundColor: primaryColor,
          body: ClipRRect(
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(50.0),
            //   topRight: Radius.circular(50.0),
            // ),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      // colorFilter: new ColorFilter.mode(
                      //     Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      image: AssetImage("asset/chat.jpg")),
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(50),
                  //     topRight: Radius.circular(50)),
                  color: Colors.white),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: chatReference
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor),
                            strokeWidth: 2,
                          ),
                        );
                      else if (snapshot.data.docs.length == 0) {
                        return Center(
                            child: Text(
                              "No Notification",
                              style: TextStyle(color: secondryColor, fontSize: 16),
                            ));
                      }


                      return Expanded(
                        child: ListView(
                          reverse: true,
                          children: generateMessages(snapshot.data.docs),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1.0),
                  Container(
                    alignment: Alignment.bottomCenter,
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    child: isBlocked
                        ? Text("Sorry You can't send message!")
                        : _buildTextComposer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDefaultSendButton() {
    return IconButton(
      icon: Transform.rotate(
        angle: -pi / 9,
        child: Icon(
          Icons.send,
          size: 25,
        ),
      ),
      color: primaryColor,
      onPressed: _isWritting
          ? () => _sendText(_textController.text.trimRight())
          : null,
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(color: _isWritting ? primaryColor : secondryColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(
                      Icons.photo_camera,
                      color: primaryColor,
                    ),
                    onPressed: () async {
                      final imagePicker = ImagePicker();
                      File imageFile;

                      Future getImage() async {
                        var image = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          imageFile = File(image.path);
                        });
                      }
                      // var image = await ImagePicker().pickImage(
                      //     source: ImageSource.gallery);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      Reference ref = FirebaseStorage
                          .instance
                          .ref()
                          .child('chats/${widget.chatId}/img_' +
                              timestamp.toString() +
                              '.jpg');
                      // UploadTask uploadTask =
                      //     storageReference.putFile(image);
                      // //await uploadTask.onComplete;
                      // String fileUrl = await ref.getDownloadURL();

                      UploadTask uploadTask = ref.putFile(imageFile);
                      uploadTask.then((res) {
                        var imageUrl= res.ref.getDownloadURL();
                        String fileUrl = imageUrl.toString();
                        _sendImage(messageText: 'Photo', imageUrl: fileUrl);
                      });



                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  maxLines: 15,
                  minLines: 1,
                  autofocus: false,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.trim().length > 0;
                    });
                  },
                  decoration: new InputDecoration.collapsed(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(18)),
                      hintText: "Send a message..."),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _sendText(String text) async {
    _textController.clear();
    chatReference.add({
      'type': 'Msg',
      'text': text,
      'sender_id': widget.sender.id,
      'receiver_id': widget.second.id,
      'isRead': false,
      'image_url': '',
      'time': FieldValue.serverTimestamp(),
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }

  void _sendImage({String messageText, String imageUrl}) {
    chatReference.add({
      'type': 'Image',
      'text': messageText,
      'sender_id': widget.sender.id,
      'receiver_id': widget.second.id,
      'isRead': false,
      'image_url': imageUrl,
      'time': FieldValue.serverTimestamp(),
    });
  }

  Future<void> onJoin(callType) async {
    if (!isBlocked) {
      // await for camera and mic permissions before pushing video page

      await handleCameraAndMic(callType);
      await chatReference.add({
        'type': 'Call',
        'text': callType,
        'sender_id': widget.sender.id,
        'receiver_id': widget.second.id,
        'isRead': false,
        'image_url': "",
        'time': FieldValue.serverTimestamp(),
      });

      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DialCall(
              channelName: widget.chatId,
              receiver: widget.second,
              callType: callType),
        ),
      );
    } else {
      CustomSnackbar.snackbar("Blocked !", _scaffoldKey);
    }
  }
}

Future<void> handleCameraAndMic(callType) async {
  callType == "VideoCall"
      ? [Permission.camera.request(), Permission.microphone.request()]
      : [Permission.microphone.request()];
  await Permission.camera.request();
}
