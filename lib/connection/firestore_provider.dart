import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lean_code_chat/tokens/in_memory_storage_token.dart';


class FirestoreProvider {
  static final tokenStorage = InMemoryTokenStorage();

  static CollectionReference getMessagesDocuments(String channelId) {
    return Firestore.instance.collection(
        'user_id/${tokenStorage.getAuthor()}/channels/$channelId/messages');
  }

  static CollectionReference getChannelsDocuments() {
    return Firestore.instance
        .collection('user_id/${tokenStorage.getAuthor()}/channels');
  }

  FirestoreProvider._new();
}
