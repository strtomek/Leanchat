import 'package:lean_code_chat/models/token_model.dart';

import 'firebase_token.dart';


 
class InMemoryTokenStorage {
 
  static final InMemoryTokenStorage _inMemoryTokenStorage = InMemoryTokenStorage._new();
 
  factory InMemoryTokenStorage() {
    return _inMemoryTokenStorage;
  }
 
  InMemoryTokenStorage._new();
 
  Token _token;
  FirebaseToken _fbToken;
 
  Future<Token> getToken() {
    return Future.value(_token);
  }
 
  Future<void> setToken(Token token) {
    return Future.sync(() {
      _token = token;
    });
  }
 
  String getAuthor() {
    return _fbToken.author;
  }
 
  Future<void> setFirebaseToken(FirebaseToken token) {
    return Future.sync(() {
      _fbToken = token;
    });
  }
 
  Future<void> wipeTokens() {
    return Future.sync(() {
      _token = null;
      _fbToken = null;
    });
  }
}