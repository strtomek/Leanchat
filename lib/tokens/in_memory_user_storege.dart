import 'package:lean_code_chat/models/user_model.dart';

class InMemoryUserStorage {
  static final InMemoryUserStorage _inMemoryUserStorage =
      InMemoryUserStorage._new();

  factory InMemoryUserStorage() {
    return _inMemoryUserStorage;
  }

  InMemoryUserStorage._new();

  User _user;

  Future<User> getUser() {
    return Future.value(_user);
  }

  Future<void> setUser(User user) {
    return Future.sync(() {
      _user = user;
    });
  }

  Future<void> wipeUser() {
    return Future.sync(() {
      _user = null;
    });
  }
}
