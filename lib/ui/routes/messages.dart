import 'package:flutter/material.dart';
import 'package:instagram/src/models/plain_models/information.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key key}) : super(key: key);
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    final _infoProvider = Provider.of<InfoModel>(context);
    return Scaffold(
      body: Center(
        child: Text('${_infoProvider.info.email}'),
      ),
    );
  }
}
