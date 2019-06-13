import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lean_code_chat/tokens/firebase_token.dart';
import 'package:lean_code_chat/tokens/in_memory_storage_token.dart';
import 'package:lean_code_chat/tokens/in_memory_user_storege.dart';
import 'package:lean_code_chat/models/avatar_user_model.dart';
import 'package:lean_code_chat/models/user_model.dart';


class ServerConnection {
  String pageUrl = 'https://api.preview.leanchat.aks.lncd.pl/';
  static InMemoryTokenStorage tokenStorage = InMemoryTokenStorage();
  static InMemoryUserStorage userStorage = InMemoryUserStorage();

  Future<http.Response> signIn(String token) async {
    final body = {
      "token": token,
      "client_id": "leanchat",
      "grant_type": "facebook",
      "scope": 'leanchat/api openid profile email offline_access'
    };

    return http.post(pageUrl + 'connect/token',
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body);
  }

  Future<http.Response> accountCreate(String token) async {
    final body = {'access_token': token};

    return http.put(pageUrl + 'user/facebook',
        headers: {"Content-Type": "application/json"}, body: body);
  }

  Future<http.Response> getAuthorized(String url) async {
    final token = await tokenStorage.getToken();
    return http
        .get(url, headers: {'Authorization': 'Bearer ${token.accessToken}'});
  }

  Future<http.Response> getFirebaseToken() async {
    final firebaseTokenResponse =
        await getAuthorized(pageUrl + "me/firebase-token");
    if (firebaseTokenResponse.statusCode == HttpStatus.ok) {
      final fbToken =
          FirebaseToken.fromJson(json.decode(firebaseTokenResponse.body));
      tokenStorage.setFirebaseToken(fbToken);
    }
    return firebaseTokenResponse;
  }

  Future<http.Response> getCurrentUser() async {
    final response = await getAuthorized(pageUrl + "me");
    if (response.statusCode == HttpStatus.ok) {
      final user = User.fromJson(json.decode(response.body));
      userStorage.setUser(user);
    }
    return response;
  }

  Future<UserAvatar> getUserPhotos(userId) async {
    final response = await getAuthorized(pageUrl + "user/$userId");
    //TODO
    // if (response.statusCode == HttpStatus) {

    // }
    return UserAvatar.fromJson(json.decode(response.body));
  }

  Future<http.Response> getGif(String phrase) async {
    return await getAuthorized(pageUrl + 'giphy?phrase=$phrase');
  }
}
