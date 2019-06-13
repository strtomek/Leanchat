import 'package:flutter/material.dart';
import 'package:lean_code_chat/models/channel_model.dart';
import 'package:lean_code_chat/models/member_model.dart';
import 'package:lean_code_chat/widgets/channel_tile_widget.dart';
import 'package:lean_code_chat/connection/firestore_provider.dart';

class ChannelPage extends StatefulWidget {
  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  List<Channel> channels = [];

  @override
  void initState() {
    setChannels();
    super.initState();
  }

  void setChannels() async {
    channels = (await FirestoreProvider.getChannelsDocuments().getDocuments())
        .documents
        .map((doc) => Channel(doc, List<Member>()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channels'),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: channels.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            return new ChannelCell(channels[index]);
          },
        ),
      ),
    );
  }
}
