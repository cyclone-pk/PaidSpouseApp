import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class  Uuser{
  final String id;
  final String name;
  final int visits;
  final bool isBlocked;
  String address;
  final Map coordinates;
  //final List sexualOrientation;
  final String gender;
  final String showGender;
  final int age;
  final String phoneNumber;
  int maxDistance;
  Timestamp lastmsg;
  final Map ageRange;
  final Map editInfo;
  List imageUrl = [];
  List videoUrl = [];
  var distanceBW;
  Uuser({
    @required this.id,
    @required this.age,
    @required this.address,
    this.isBlocked,
    this.coordinates,
    @required this.name,
    @required this.imageUrl,
    this.videoUrl,
    this.visits,
    this.phoneNumber,
    this.lastmsg,
    this.gender,
    this.showGender,
    this.ageRange,
    this.maxDistance,
    this.editInfo,
    this.distanceBW,
    // this.sexualOrientation,
  });
  factory Uuser.fromMap(Map doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return Uuser(

        id: doc['userId'],
        isBlocked: doc['isBlocked'] != null ? doc['isBlocked'] : false,
        phoneNumber: doc['phoneNumber'],
        name: doc['UserName'],
        visits: doc['visits'],
        editInfo: doc['editInfo'],
        ageRange: doc['age_range'],
        showGender: doc['showGender'],
        maxDistance: doc['maximum_distance'],
        //sexualOrientation: doc['sexualOrientation']['orientation'] ?? "",
        age: ((DateTime.now()
                    .difference(DateTime.parse(doc["user_DOB"]))
                    .inDays) /
                365.2425)
            .truncate(),
        address: doc['location']['address'],
        coordinates: doc['location'],
        // university: doc['editInfo']['university'],
        videoUrl: doc['Videos'] != null
            ? List.generate(doc['Videos'].length, (index) {
                return doc['Videos'][index];
              })
            : [],
        imageUrl: doc['Pictures'] != null
            ? List.generate(doc['Pictures'].length, (index) {
                return doc['Pictures'][index];
              })
            : []);
  }
}
