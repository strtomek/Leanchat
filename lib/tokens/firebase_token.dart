class FirebaseToken {
  factory FirebaseToken.fromJson(Map<String, dynamic> json) {
    return FirebaseToken(
        accessToken: json['access_token'], author: json['author']);
  }
 
  FirebaseToken({this.accessToken, this.author});
 
  String accessToken;
  String author;
}