import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matriapp/models/user_model.dart';

class Notify {
  final Uuser sender;
  final Timestamp time;
  final bool isRead;

  Notify({
    this.sender,
    this.time,
    this.isRead,
  });
}
