import 'package:flutter/material.dart';
import 'package:lean_code_chat/models/channel_model.dart';
import 'package:lean_code_chat/pages/message_page.dart';

class ChannelCell extends StatelessWidget {
  Channel channel;

  ChannelCell(this.channel);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        channel.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      leading: Container(
        width: 40,
        height: 30,
        child: ClipRRect(
          child: Image.network(channel.photo),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      subtitle: Text('Numbers of users: ${channel.members.length}'),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MessagePage(channel.id, channel.name);
            },
          ),
        );
      },
    );
  }
}
