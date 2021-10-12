import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:matriapp/ads/ads.dart';
import 'package:image/image.dart' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matriapp/models/user_model.dart';
import 'package:matriapp/util/color.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class EditProfile extends StatefulWidget {
  final Uuser currentUser;
  EditProfile(this.currentUser);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController aboutCtlr = new TextEditingController();
  final TextEditingController companyCtlr = new TextEditingController();
  final TextEditingController salaryCtlr = new TextEditingController();
  final TextEditingController offerCtlr = new TextEditingController();
  final TextEditingController demandCtlr = new TextEditingController();
  final TextEditingController interestsCtlr = new TextEditingController();
  final TextEditingController heightCtlr = new TextEditingController();
  final TextEditingController weightCtlr = new TextEditingController();
  final TextEditingController colorCtlr = new TextEditingController();
  final TextEditingController livingCtlr = new TextEditingController();
  final TextEditingController jobCtlr = new TextEditingController();
  final TextEditingController castCtlr = new TextEditingController();
  final TextEditingController universityCtlr = new TextEditingController();
  final TextEditingController heightpCtlr = new TextEditingController();
  final TextEditingController tonguepCtlr = new TextEditingController();
  final TextEditingController religionpCtlr = new TextEditingController();
  final TextEditingController countrypCtlr = new TextEditingController();
  final TextEditingController statepCtlr = new TextEditingController();
  final TextEditingController citypCtlr = new TextEditingController();
  final TextEditingController qualificationpCtlr = new TextEditingController();
  final TextEditingController professionpCtlr = new TextEditingController();
  final TextEditingController jobpCtlr = new TextEditingController();

  Map<String, dynamic> changeValues = {};
  bool visibleAge = false;
  bool visibleDistance = true;
  bool isLoading = false;
  RangeValues ageRange;
  var showMe;
  var showPro;
  var showType;
  var showMar;
  var showMarp;
  Map editInfo = {};
  Ads _ads = new Ads();
  BannerAd _ad;
  @override
  void initState() {
    super.initState();
    aboutCtlr.text = widget.currentUser.editInfo['about'];
    companyCtlr.text = widget.currentUser.editInfo['company'];
    salaryCtlr.text = widget.currentUser.editInfo['salary'];
    offerCtlr.text = widget.currentUser.editInfo['offer'];
    demandCtlr.text = widget.currentUser.editInfo['demand'];
    interestsCtlr.text = widget.currentUser.editInfo['interests'];
    heightCtlr.text = widget.currentUser.editInfo['height'];
    weightCtlr.text = widget.currentUser.editInfo['weight'];
    colorCtlr.text = widget.currentUser.editInfo['color'];
    livingCtlr.text = widget.currentUser.editInfo['living_in'];
    universityCtlr.text = widget.currentUser.editInfo['university'];
    jobCtlr.text = widget.currentUser.editInfo['job_title'];
    heightpCtlr.text = widget.currentUser.editInfo['height_p'];
    tonguepCtlr.text = widget.currentUser.editInfo['tongue_p'];
    religionpCtlr.text = widget.currentUser.editInfo['religion_p'];
    countrypCtlr.text = widget.currentUser.editInfo['country_p'];
    statepCtlr.text = widget.currentUser.editInfo['state_p'];
    citypCtlr.text = widget.currentUser.editInfo['city_p'];
    qualificationpCtlr.text = widget.currentUser.editInfo['qualification_p'];
    jobpCtlr.text = widget.currentUser.editInfo['job_p'];
    professionpCtlr.text = widget.currentUser.editInfo['profession_p'];
    castCtlr.text = widget.currentUser.editInfo['cast'];
    setState(() {
      showMe = widget.currentUser.editInfo['userGender'];
      showPro = widget.currentUser.editInfo['profession'];
      showType = widget.currentUser.editInfo['type'];
      showMar = widget.currentUser.editInfo['marital_status'];
      showMarp = widget.currentUser.editInfo['marital_status_p'];

      visibleAge = widget.currentUser.editInfo['showMyAge'] ?? false;
      visibleDistance = widget.currentUser.editInfo['DistanceVisible'] ?? true;
      ageRange = RangeValues(double.parse(widget.currentUser.ageRange['min']),
          (double.parse(widget.currentUser.ageRange['max'])));
    });

    _ad = _ads.myBanner();
    super.initState();
    _ad
      ..load()
      ..show();
  }

  @override
  void dispose() {
    super.dispose();
    print(editInfo.length);
    if (editInfo.length > 0) {
      updateData();
    }
    _ads.disable(_ad);
    if (changeValues.length > 0) {
      updateDataa();
    }
  }

  Future updateDataa() async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.currentUser.id)
        .set(changeValues, SetOptions(merge: true));
    // lastVisible = null;
    // print('ewew$lastVisible');
  }

  Future updateData() async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.currentUser.id)
        .set({'editInfo': editInfo, 'age': widget.currentUser.age},
            SetOptions(merge: true));
  }

  Future source(
      BuildContext context, currentUser, bool isProfilePicture) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(
                  isProfilePicture ? "Update profile picture" : "Add Media"),
              content: Text(
                "Select source",
              ),
              insetAnimationCurve: Curves.decelerate,
              actions: currentUser.imageUrl.length < 9
                  ? <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                size: 28,
                              ),
                              Text(
                                " Camera",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.camera, context,
                                      currentUser, isProfilePicture);
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_library,
                                size: 28,
                              ),
                              Text(
                                " Gallery",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.gallery, context,
                                      currentUser, isProfilePicture);
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                      // widget.currentUser.videoUrl.length != 3
                      //     ?
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.video_library,
                                size: 28,
                              ),
                              Text(
                                " Video",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  uploadVideo(currentUser);
                                  return isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ))
                                      : Center();
                                });
                          },
                        ),
                      )
                      // : Center(
                      //     child: Text(
                      //     " 3 Videos Allowed",
                      //     style: TextStyle(
                      //         fontSize: 15,
                      //         color: Colors.black,
                      //         decoration: TextDecoration.none),
                      //   )),
                    ]
                  : [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(Icons.error),
                            Text(
                              "Can't uplaod more than 9 pictures",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        )),
                      )
                    ]);
        });
  }

  Future getImage(
      ImageSource imageSource, context, currentUser, isProfilePicture) async {
    var image = await ImagePicker().pickImage(source: imageSource);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: pinkColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        await uploadFile(
            await compressimage(croppedFile), currentUser, isProfilePicture);
      }
    }
    Navigator.pop(context);
  }

  Future uploadFile(File image, Uuser currentUser, isProfilePicture) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${currentUser.id}/${image.hashCode}.jpg');
    UploadTask uploadTask = storageReference.putFile(image);
    //if (uploadTask == true) {}
    if (await uploadTask != null) {
      storageReference.getDownloadURL().then((fileURL) async {
        Map<String, dynamic> updateObject = {
          "Pictures": FieldValue.arrayUnion([
            fileURL,
          ])
        };
        try {
          if (isProfilePicture) {
            //currentUser.imageUrl.removeAt(0);
            currentUser.imageUrl.insert(0, fileURL);
            print("object");
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.id)
                .set({"Pictures": currentUser.imageUrl}, SetOptions(merge: true));
          } else {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.id)
                .set(updateObject, SetOptions(merge: true));
            widget.currentUser.imageUrl.add(fileURL);
          }
          if (mounted) setState(() {});
        } catch (err) {
          print("Error: $err");
        }
      });
    }
  }

  Future compressimage(File image) async {
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    i.Image imagefile = i.decodeImage(image.readAsBytesSync());
    final compressedImagefile = File('$path.jpg')
      ..writeAsBytesSync(i.encodeJpg(imagefile, quality: 80));
    // setState(() {
    return compressedImagefile;
    // });
  }

  Future uploadVideo(Uuser currentUser) async {
    if (currentUser.videoUrl.length != 3) {
      //isLoading = true;
      //final file = await ImagePicker().pickVideo(source: ImageSource.camera);
      final imagePicker = ImagePicker();
      File imageFile;
      Future getImage() async {
        var image = await imagePicker.pickVideo(source: ImageSource.camera);
        setState(() {
          imageFile = File(image.path);
        });
      }
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('users/${currentUser.id}/videos/${imageFile.hashCode}.mp4');




      UploadTask uploadTask = storageReference.putFile(
          imageFile, SettableMetadata(contentType: 'video/mp4'));
      //if (uploadTask.isInProgress == true) {}
      if (await uploadTask != null) {
        storageReference.getDownloadURL().then((fileURL) async {
          Map<String, dynamic> updateObject = {
            "Videos": FieldValue.arrayUnion([
              fileURL,
            ])
          };
          // setState(() {
          //   isLoading = false;
          //   print("Donee");
          // });
          try {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.id)
                .set(updateObject, SetOptions(merge: true));
            //print("Errorrr: $fileURL");

            widget.currentUser.videoUrl.add(fileURL);

            if (mounted) setState(() {});
          } catch (err) {
            print("Error: $err");
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Only 3 Videos Allowed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Profile _profile = new Profile(widget.currentUser);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [pinkColor, appColor]))),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        //backgroundColor: primaryColor
      ),
      body: Scaffold(
        //  backgroundColor: primaryColor,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Colors.white),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .65,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio:
                            MediaQuery.of(context).size.aspectRatio * 1.5,
                        crossAxisSpacing: 4,
                        padding: EdgeInsets.all(10),
                        children: List.generate(9, (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: widget.currentUser.imageUrl.length >
                                        index
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // image: DecorationImage(
                                        //     fit: BoxFit.cover,
                                        //     image: CachedNetworkImageProvider(
                                        //       widget.currentUser.imageUrl[index],
                                        //     )),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            style: BorderStyle.solid,
                                            width: 1,
                                            color: secondryColor)),
                                child: Stack(
                                  children: <Widget>[
                                    widget.currentUser.imageUrl.length > index
                                        ? CachedNetworkImage(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            fit: BoxFit.cover,
                                            imageUrl: widget.currentUser
                                                    .imageUrl[index] ??
                                                '',
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CupertinoActivityIndicator(
                                                radius: 10,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.error,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  Text(
                                                    "Enable to load",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    // Center(
                                    //     child:
                                    //         widget.currentUser.imageUrl.length >
                                    //                 index
                                    //             ? CupertinoActivityIndicator(
                                    //                 radius: 10,
                                    //               )
                                    //             : Container()),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                          // width: 12,
                                          // height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.currentUser.imageUrl
                                                        .length >
                                                    index
                                                ? Colors.white
                                                : pinkColor,
                                          ),
                                          child: widget.currentUser.imageUrl
                                                      .length >
                                                  index
                                              ? InkWell(
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: pinkColor,
                                                    size: 22,
                                                  ),
                                                  onTap: () async {
                                                    if (widget.currentUser
                                                            .imageUrl.length >
                                                        1) {
                                                      _deletePicture(index);
                                                    } else {
                                                      source(
                                                          context,
                                                          widget.currentUser,
                                                          true);
                                                    }
                                                  },
                                                )
                                              : InkWell(
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    size: 22,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () => source(
                                                      context,
                                                      widget.currentUser,
                                                      false),
                                                )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                  widget.currentUser.videoUrl.length == 0
                      ? Container()
                      : Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: Swiper(
                            key: UniqueKey(),
                            physics: ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index2) {
                              return widget.currentUser.videoUrl.length != null
                                  ? Hero(
                                      tag: "abc",
                                      child: VideoWidget(
                                          play: true,
                                          url: widget.currentUser
                                                  .videoUrl[index2] ??
                                              ''),
                                    )
                                  : Container();
                            },
                            itemCount: widget.currentUser.videoUrl.length,
                            // pagination: new SwiperPagination(
                            //     alignment: Alignment.bottomCenter,
                            //     builder: DotSwiperPaginationBuilder(
                            //         activeSize: 5,
                            //         color: secondryColor,
                            //         activeColor: primaryColor)),
                            control: new SwiperControl(
                              color: pinkColor,
                              disableColor: secondryColor,
                            ),
                            loop: false,
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient:
                                LinearGradient(colors: [pinkColor, appColor])),
                        height: 50,
                        width: 340,
                        child: Center(
                            child: Text(
                          "Add media",
                          style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      await source(context, widget.currentUser, false);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListBody(
                      mainAxis: Axis.vertical,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "About ${widget.currentUser.name}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: aboutCtlr,
                            cursorColor: pinkColor,
                            maxLines: 10,
                            minLines: 3,
                            placeholder: "About you",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'about': text});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              "Select Offer or Demand",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: DropdownButton(
                              iconEnabledColor: primaryColor,
                              iconDisabledColor: secondryColor,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Offer"),
                                  value: "offer",
                                ),
                                DropdownMenuItem(
                                    child: Text("Demand"), value: "demand"),
                                DropdownMenuItem(
                                    child: Text("Nothing"), value: "nothing"),
                              ],
                              onChanged: (val) {
                                editInfo.addAll({'type': val});
                                setState(() {
                                  showType = val;
                                });
                              },
                              value: showType,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        editInfo['type'] == 'offer'
                            ? ListTile(
                                title: Text(
                                  "House son in law, Property share, Shelter, Pocket Money, Salary share, Job, Business, Basic needs of life etc.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: primaryColor),
                                ),
                                subtitle: CupertinoTextField(
                                  controller: offerCtlr,
                                  cursorColor: primaryColor,
                                  maxLines: 10,
                                  minLines: 3,
                                  placeholder:
                                      "Write any offer using above guide line",
                                  padding: EdgeInsets.all(10),
                                  onChanged: (text) {
                                    editInfo.addAll({'offer': text});
                                  },
                                ),
                              )
                            : Container(),
                        editInfo['type'] == 'demand'
                            ? ListTile(
                                title: Text(
                                  "House son in law, Property share, Shelter, Pocket Money, Salary share, Job, Business, Basic needs of life etc.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: primaryColor),
                                ),
                                subtitle: CupertinoTextField(
                                  controller: demandCtlr,
                                  cursorColor: primaryColor,
                                  maxLines: 10,
                                  minLines: 3,
                                  placeholder:
                                      "Write any demand using above guide line",
                                  padding: EdgeInsets.all(10),
                                  onChanged: (text) {
                                    editInfo.addAll({'demand': text});
                                  },
                                ),
                              )
                            : Container(),
                        ListTile(
                          title: Text(
                            "Interests",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: interestsCtlr,
                            cursorColor: primaryColor,
                            maxLines: 10,
                            minLines: 3,
                            placeholder: "Add interests",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'interests': text});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              "Profession",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: DropdownButton(
                              iconEnabledColor: primaryColor,
                              iconDisabledColor: secondryColor,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Business"),
                                  value: "business",
                                ),
                                DropdownMenuItem(
                                    child: Text("Job"), value: "job"),
                                DropdownMenuItem(
                                    child: Text("Other"), value: "other"),
                              ],
                              onChanged: (val) {
                                editInfo.addAll({'profession': val});
                                setState(() {
                                  showPro = val;
                                });
                              },
                              value: showPro,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text(
                            "Job title",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: jobCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Working at present",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'job_title': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Salary",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: salaryCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add Salary",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'salary': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Company",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: companyCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add company",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'company': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Qualification",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: universityCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add qualification",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'university': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Living in (City)",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: livingCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add city",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'living_in': text});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              "Marital Status",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: DropdownButton(
                              iconEnabledColor: primaryColor,
                              iconDisabledColor: secondryColor,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Single"),
                                  value: "single",
                                ),
                                DropdownMenuItem(
                                    child: Text("Married"), value: "married"),
                                DropdownMenuItem(
                                    child: Text("Divorced"), value: "divorced"),
                              ],
                              onChanged: (val) {
                                editInfo.addAll({'marital_status': val});
                                setState(() {
                                  showMar = val;
                                });
                              },
                              value: showMar,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text(
                            "Cast",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: castCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add cast",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'cast': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Height",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: heightCtlr,
                            cursorColor: primaryColor,
                            placeholder: "5.5 Feet",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'height': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Weight",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: weightCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Add weight",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'weight': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Color",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: colorCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Fair, White, Black etc",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'color': text});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              "I am",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: DropdownButton(
                              iconEnabledColor: primaryColor,
                              iconDisabledColor: secondryColor,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Man"),
                                  value: "man",
                                ),
                                DropdownMenuItem(
                                    child: Text("Woman"), value: "woman"),
                              ],
                              onChanged: (val) {
                                editInfo.addAll({'userGender': val});
                                setState(() {
                                  showMe = val;
                                });
                              },
                              value: showMe,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                            title: Text(
                              "Control your profile",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Don't Show My Age"),
                                      ),
                                      Switch(
                                          activeColor: primaryColor,
                                          value: visibleAge,
                                          onChanged: (value) {
                                            editInfo
                                                .addAll({'showMyAge': value});
                                            setState(() {
                                              visibleAge = value;
                                            });
                                          })
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Make My Distance Visible"),
                                      ),
                                      Switch(
                                          activeColor: primaryColor,
                                          value: visibleDistance,
                                          onChanged: (value) {
                                            editInfo.addAll(
                                                {'DistanceVisible': value});
                                            setState(() {
                                              visibleDistance = value;
                                            });
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Padding(
                          child: Text(
                            "Partner Basic Info",
                            style: TextStyle(fontSize: 20, color: primaryColor),
                          ),
                          padding: EdgeInsets.only(left: 15, top: 40),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  "Age range",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: Text(
                                  "${ageRange.start.round()}-${ageRange.end.round()}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                subtitle: RangeSlider(
                                    inactiveColor: secondryColor,
                                    values: ageRange,
                                    min: 18.0,
                                    max: 100.0,
                                    divisions: 25,
                                    activeColor: primaryColor,
                                    labels: RangeLabels(
                                        '${ageRange.start.round()}',
                                        '${ageRange.end.round()}'),
                                    onChanged: (val) {
                                      changeValues.addAll({
                                        'age_range': {
                                          'min': '${val.start.truncate()}',
                                          'max': '${val.end.truncate()}'
                                        }
                                      });
                                      setState(() {
                                        ageRange = val;
                                      });
                                    }),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              "Marital Status",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: DropdownButton(
                              iconEnabledColor: primaryColor,
                              iconDisabledColor: secondryColor,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Single"),
                                  value: "single",
                                ),
                                DropdownMenuItem(
                                    child: Text("Married"), value: "married"),
                                DropdownMenuItem(
                                    child: Text("Divorced"), value: "divorced"),
                              ],
                              onChanged: (val) {
                                editInfo.addAll({'marital_status_p': val});
                                setState(() {
                                  showMarp = val;
                                });
                              },
                              value: showMarp,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Partner Height",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: heightpCtlr,
                            cursorColor: primaryColor,
                            placeholder: "5.6 Feet",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'height_p': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Partner Religion",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: religionpCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Muslum, Hindu etc",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'religion_p': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Mother tongue",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: tonguepCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Englisg, Urdu, Hindi etc",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'tongue_p': text});
                            },
                          ),
                        ),
                        Padding(
                          child: Text(
                            "Partner Location Details",
                            style: TextStyle(fontSize: 20, color: primaryColor),
                          ),
                          padding: EdgeInsets.only(left: 15, top: 40),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text(
                            "Country living in",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: countrypCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Partner Country",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'country_p': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "State living in",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: statepCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Partner State",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'state_p': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "City living in",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: citypCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Partner City",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'city_p': text});
                            },
                          ),
                        ),
                        Padding(
                          child: Text(
                            "Partner Education & Career",
                            style: TextStyle(fontSize: 20, color: primaryColor),
                          ),
                          padding: EdgeInsets.only(left: 15, top: 40),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text(
                            "Qualification",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: qualificationpCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Partner qualification",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'qualification_p': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Job Title",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: jobpCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Partner job",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'job_p': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Profession Area",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: professionpCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Partner profession",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'profession_p': text});
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deletePicture(index) async {
    if (widget.currentUser.imageUrl[index] != null) {
      try {
        Reference _ref = FirebaseStorage.instance
            .refFromURL(widget.currentUser.imageUrl[index]);
       // print(_ref.path);
        await _ref.delete();
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      widget.currentUser.imageUrl.removeAt(index);
    });
    var temp = [];
    temp.add(widget.currentUser.imageUrl);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc("${widget.currentUser.id}")
        .set({"Pictures": temp[0]}, SetOptions(merge: true));
  }
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
