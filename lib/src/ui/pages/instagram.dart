// View with DATA after Authenticated Login
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/src/core/services/handle_snapshot.dart';
import 'package:instagram/src/core/services/profile_adapter.dart';
import 'package:instagram/src/models/plain_models/information.dart';
import 'package:instagram/src/models/plain_models/profile.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/models/view_models/feed.dart';
import 'package:instagram/src/ui/components/handle_view_show.dart';
import 'package:instagram/src/ui/pages/messages.dart';
import 'package:instagram/src/ui/pages/story.dart';
import 'package:instagram/src/ui/pages/upload.dart';
import 'package:provider/provider.dart';

import 'profile_page.dart';

class Instagram extends StatefulWidget {
  final FirebaseUser user;

  const Instagram({Key key, this.user}) : super(key: key);
  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  PageController _page1Controller, _page2Controller;
  ProfileAdapter profileAdapter = ProfileAdapter();
  int _buttonIndex = 0;
  bool loaded = false;

  _setIndex(int index) {
    setState(() {
      _buttonIndex = index;
    });
  }

  _isOutlineOrFilled(int ofIndex) {
    if (ofIndex == _buttonIndex) {
      return 'Filled';
    } else {
      return 'Outline';
    }
  }

  @override
  initState() {
    _page1Controller = PageController(initialPage: 0);
    _page2Controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<InfoModel>(context);
    final _userRepo = Provider.of<UserRepository>(context);
    return MaterialApp(
      theme: ThemeData(
        cursorColor: Colors.teal,
        textSelectionColor: Color(0x550077ff),
        textSelectionHandleColor: Colors.teal,
        primaryTextTheme: TextTheme(title: TextStyle(color: Color(0xff262626))),
        appBarTheme: AppBarTheme(
          elevation: 2,
          brightness: Brightness.light,
          color: Colors.grey[100],
          iconTheme: IconThemeData(color: Colors.black),
        ),
        splashColor: Colors.transparent,
      ),
      home: Scaffold(
        body: PageView(
          controller: _page2Controller,
          children: <Widget>[
            HandleSnapshot(
              future: profileAdapter.getProfileSnapshot(_userRepo.user),
              builder:
                  (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
                loaded = true;
                // data.modifyInfo(Profile.fromMap(snapshot.data));
                data.info = Profile.fromMap(snapshot.data);
                if (data != null) {
                  return PageView(
                    controller: _page1Controller,
                    children: <Widget>[HomePage(), MessagePage()],
                  );
                } else {
                  return Text('There\'s an issue');
                }
              },
            ),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                spreadRadius: -6,
              ),
            ],
          ),
          child: Container(
            height: 50,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setIndex(0),
                    child: Image(
                      image: AssetImage(
                          'assets/res_icons/home${_isOutlineOrFilled(0)}.png'),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setIndex(1),
                    child: Image(
                      image: AssetImage(
                          'assets/res_icons/search${_isOutlineOrFilled(1)}.png'),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _setIndex(2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadPage(),
                        ),
                      );
                    },
                    child: Image(
                      image: AssetImage('assets/res_icons/newPost.png'),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setIndex(3),
                    child: Image(
                      image: AssetImage(
                          'assets/res_icons/heart${_isOutlineOrFilled(3)}.png'),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _setIndex(4);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                    child: Image(
                      image: AssetImage(
                          'assets/res_icons/user${_isOutlineOrFilled(4)}.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _page1Controller.dispose();
    _page2Controller.dispose();
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
  ProfileAdapter profileAdapter = ProfileAdapter();

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
    final _feedModel = Provider.of<FeedModel>(context);
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
