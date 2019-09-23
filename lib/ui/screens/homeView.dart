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

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PageController _pageController;
  @override
  initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[HomePage(), MessagePage()],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loaded = false;
  DatabaseReference _databaseReference = new FirebaseDatabase().reference();
  List<dynamic> followerList;
  ProfileService profileAdapter = ProfileService();

  Widget _feedView(BuildContext context) {
    final _data = Provider.of<InfoModel>(context);
    if (_data.info?.followers != null) {
      // && data.followers[1].isNotEmpty
      followerList = _data.info.followers;
      debugPrint('Followers: $followerList');
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

  @override
  Widget build(BuildContext context) {
    final _feedModel = Provider.of<MessageNotificationModel>(context);
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
                Visibility(
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
                ),
              ],
            ),
          ),
        ],
      ),
      body: _feedView(context),
    );
  }
}
