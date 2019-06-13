import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'member_model.dart';

class Channel {
  factory Channel(DocumentSnapshot doc, List<Member> members) {
    if (doc == null || !doc.exists) {
      return null;
    }

    return Channel._new()
      ..id = doc.documentID
      ..name = doc.data['name']
      ..photo = doc.data['photo']
      ..members = members;
  }

  Channel._new();

  String id;
  String name;
  String photo;
  List<Member> members;
}
