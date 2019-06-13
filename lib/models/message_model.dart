import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  factory Message.fromSnapshot(DocumentSnapshot doc, String currentUserId) {
    if (doc == null || !doc.exists) {
      return null;
    }

    final Timestamp timestamp = doc.data['timestamp'];
    final String userId = doc.data['from'];
    return Message._new()
      ..id = doc.documentID
      ..from = userId
      ..message = doc.data['message']
      ..gif = doc.data['gif']
      ..timestamp = timestamp.toDate()
      ..mine = userId == currentUserId;
  }

  factory Message.fromData(String userId, String message, String gif) {
    return Message._new()
      ..id = ""
      ..from = userId
      ..message = message
      ..gif = gif
      ..timestamp = DateTime.now();
  }

  Message._new();

  String id;
  String from;
  String message;
  String gif;
  DateTime timestamp;
  bool mine = false;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'timestamp': timestamp,
      'message': message,
      'gif': gif
    };
  }

  bool hasMessage() {
    return message != null && message.isNotEmpty;
  }
}
