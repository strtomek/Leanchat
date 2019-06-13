class Token {
  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        accessToken: json['access_token'], refreshToken: json['refresh_token']);
  }

  Token({this.accessToken, this.refreshToken});

  String accessToken;
  String refreshToken;
}
