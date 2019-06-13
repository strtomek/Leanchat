import 'package:flutter/material.dart';
import 'package:lean_code_chat/models/avatar_user_model.dart';
import 'package:lean_code_chat/models/message_model.dart';

typedef Future<UserAvatar> GetAvatar(String id);

class MessageCell extends StatelessWidget {
  Message message;
  String avatar;
  GetAvatar getAvatar;

  MessageCell(this.message, this.getAvatar);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: message.mine != true
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              height: 40,
              child: FutureBuilder<UserAvatar>(
                future: getAvatar(message.from),
                builder: (_, avatar) {
                  if (avatar.data != null) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(avatar.data.avatar),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Flexible(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${message.timestamp}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.00),
                    child: Container(
                      color: message.mine != false
                          ? Colors.blueAccent
                          : Colors.green,
                      padding: EdgeInsets.all(12),
                      child: message.message != null
                          ? Text(message.message ?? '')
                          : Image.network(message.gif),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
