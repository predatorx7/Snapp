import 'package:flutter/material.dart';
import 'package:instagram/ui/components/bottom_navbar.dart';
import '../../models/plain_models/information.dart';
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
      bottomNavigationBar: Material(
        elevation: 5,
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: kBottomNavigationBarHeight),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FlatButton(
                  onPressed: () {
                    print('Tapped camera');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Camera'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
