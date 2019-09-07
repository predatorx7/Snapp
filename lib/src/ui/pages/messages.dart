import 'package:flutter/material.dart';
import 'package:instagram/src/models/plain_models/profile.dart';

class MessagePage extends StatefulWidget {
  final Profile profileInformation;
  const MessagePage({Key key, this.profileInformation})
      : super(key: key);
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('${widget.profileInformation.email}')),
    );
  }
}
