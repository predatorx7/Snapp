import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import '../listusers.dart';

class MessagingPage extends StatefulWidget {
  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  InfoModel _user;
  @override
  void didChangeDependencies() {
    _user = Provider.of<InfoModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Direct',
          style: actionTitleStyle(),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListUsers(
                    users: _user.info.follows,
                    title: 'Following',
                  ),
                ),
              );
            },
            icon: Icon(
              OMIcons.addComment,
              color: notBlack,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: outlineTextField(
                hintText: 'Search',
              ),
            ),
          ),
        ],
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
