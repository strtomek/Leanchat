class User {
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'],
        email: json['email'],
        fbId: json['fbId']);
  }
 
  User({this.id, this.name, this.avatar, this.email, this.fbId});
 
  final String id;
  final String name;
  final String avatar;
  final String email;
  final String fbId;
}