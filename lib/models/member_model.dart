class Member {
  factory Member.fromJson(Map<String, dynamic> json, {String seenMessageId = ""}) {
    return Member(id: json['id'], name: json['name'], photo: json['photo'], seenMessageId: seenMessageId);
  }
 
  Member({this.id, this.name, this.photo, this.seenMessageId});
 
  final String id;
  final String name;
  final String photo;
  final String seenMessageId;
}