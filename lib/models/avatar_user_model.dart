class UserAvatar {
  factory UserAvatar.fromJson(Map<String, dynamic> json) {
    return UserAvatar(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  UserAvatar({this.id, this.name, this.avatar});

  final String id;
  final String name;
  final String avatar;
}
