import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/ui/components/handle_view_show.dart';
import '../../models/view_models/message_notification.dart';
import 'package:instagram/ui/screens/messages.dart';
import 'package:provider/provider.dart';

import 'story.dart';

class ProfileView extends StatefulWidget {
  InfoModel data;
  ProfileView({@required this.data});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool loaded = false;
  DatabaseReference _databaseReference = new FirebaseDatabase().reference();
  ProfileService profileAdapter = ProfileService();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Feed Model Data; ${widget.data.info.toJson().toString()}');
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => StoryPick(),
                    ),
                  );
                },
                child: Image(
                  image: AssetImage('assets/res_icons/cameraOutline.png'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image(
                image: AssetImage('assets/res_image/logo.png'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MessagePage(),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  child: Image(
                    image: AssetImage('assets/res_icons/directOutline.png'),
                  ),
                ),
                ChangeNotifierProvider(
                  builder: (context) => MessageNotificationModel(),
                  child: Consumer(
                    builder: (BuildContext context,
                        MessageNotificationModel _feedModel, _) {
                      return Visibility(
                        visible: _feedModel.getMessageCount() != 0,
                        child: Positioned(
                          right: 5,
                          top: 5,
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${_feedModel.getMessageCount()}',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _FeedView(data: widget.data),
    );
  }
}

class _FeedView extends StatefulWidget {
  InfoModel data;
  _FeedView({this.data});
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> {
  bool isListNotEmpty;
  DatabaseReference _databaseReference = new FirebaseDatabase().reference();
  List<dynamic> followerList;
  ProfileService profileAdapter = ProfileService();

  @override
  Widget build(BuildContext context) {
    print('[Home\'s List View] Setting up Posts');
    List followerList = widget.data.info.followers;
    print('[FeedView] Info: ${widget.data.info.toJson().toString()}');
    isListNotEmpty = followerList.isNotEmpty;
    // if (false) {
    if (isListNotEmpty ? followerList[0].isNotEmpty : true) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return HandleViewSnapshot(
            future: _databaseReference
                .child(
                    'posts/${followerList[index].isNotEmpty ? followerList[index] : followerList[index + 1]}')
                .orderByChild("creationTime")
                .onValue
                .last
                .then(
              (Event onValue) {
                return onValue.snapshot;
              },
            ),
            builder: (BuildContext context,
                AsyncSnapshot<DataSnapshot> asyncSnapshot) {
              return Text(asyncSnapshot.data.value);
            },
          );
        },
      );
    } else {
      return Center(
        child: Text('You are not following anyone'),
      );
    }
  }
}
