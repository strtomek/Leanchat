import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lean_code_chat/connection/firestore_provider.dart';
import 'package:lean_code_chat/models/message_model.dart';
import 'package:lean_code_chat/connection/server_connection.dart';
import 'package:lean_code_chat/widgets/message_cell_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagePage extends StatefulWidget {
  String channelId;
  String channelName;
  MessagePage(this.channelId, this.channelName);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> messages = [];
  final myController = TextEditingController();
  StreamSubscription<QuerySnapshot> subscription;
  final ServerConnection serverConnection = ServerConnection();

  @override
  void dispose() {
    myController.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    setMessages();
    subscription = FirestoreProvider.getMessagesDocuments(widget.channelId)
        .snapshots()
        .listen((_) => setMessages());

    super.initState();
  }

  void setMessages() async {
    var user = await ServerConnection.userStorage.getUser();
    messages = (await FirestoreProvider.getMessagesDocuments(widget.channelId)
            .getDocuments())
        .documents
        .map((doc) => Message.fromSnapshot(doc, user.id))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            iconSize: 45.00,
            icon: Icon(Icons.gif),
            onPressed: () async {
              var gifResult = await serverConnection.getGif('cat');
              var gif = json.decode(gifResult.body)['url'];
              var user = await ServerConnection.userStorage.getUser();
              FirestoreProvider.getMessagesDocuments(widget.channelId)
                  .add(Message.fromData(user.id, null, gif).toMap());
            },
          )
        ],
        title: Center(
          child: Text(widget.channelName),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              reverse: true,
              itemCount: messages.length,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                final sorted = messages.toList();
                sorted.sort((a, b) =>
                    b.timestamp.difference(a.timestamp).inMilliseconds);
                return MessageCell(
                  sorted[index],
                  serverConnection.getUserPhotos,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      cursorColor: Colors.green,
                      cursorRadius: Radius.circular(16.0),
                      cursorWidth: 16.0,
                      controller: myController,
                      decoration: InputDecoration(
                        hintText: '     Enter message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    color: Colors.green,
                    child: Text('Send'),
                    onPressed: () async {
                      var user = await ServerConnection.userStorage.getUser();
                      FirestoreProvider.getMessagesDocuments(widget.channelId)
                          .add(Message.fromData(user.id, myController.text, '')
                              .toMap());
                      myController.clear();
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
