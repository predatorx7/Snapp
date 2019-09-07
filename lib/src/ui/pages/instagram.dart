// View with DATA after Authenticated Login
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/src/core/services/handle_snapshot.dart';
import 'package:instagram/src/core/services/profile_adapter.dart';
import 'package:instagram/src/models/plain_models/profile.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/models/view_models/feed.dart';
import 'package:instagram/src/ui/pages/messages.dart';
import 'package:instagram/src/ui/pages/upload.dart';
import 'package:provider/provider.dart';

class Instagram extends StatefulWidget {
  final FirebaseUser user;

  const Instagram({Key key, this.user}) : super(key: key);
  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  Profile data;
  ProfileAdapter profileAdapter = ProfileAdapter();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feedModel = Provider.of<FeedModel>(context);
    final userRepo = Provider.of<UserRepository>(context);
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
        appBar: AppBar(
          title: Container(
            height: 40,
            child: Row(
              children: <Widget>[
                GestureDetector(
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
                    builder: (context) => MessagePage(
                      // Gets data from async snapshot
                      profileInformation: data,
                    ),
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
                    visible: feedModel.getMessageCount() != 0,
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
                          '${feedModel.getMessageCount()}',
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
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Email: ${userRepo.user.email}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Status: ${userRepo.status}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                HandleSnapshot(
                  future: profileAdapter.getProfileSnapshot(userRepo.user),
                  builder: (BuildContext context,
                      AsyncSnapshot<DataSnapshot> snapshot) {
                    data = Profile.fromMap(snapshot.data, userRepo.user.uid);
                    return new Text('Username: ${data.email}');
                  },
                ),
              ],
            ),
            ButtonBar(
              children: <Widget>[
                OutlineButton(
                  borderSide: BorderSide(color: Colors.red),
                  highlightedBorderColor: Colors.redAccent,
                  textColor: Colors.red,
                  child: Text("SIGN OUT"),
                  onPressed: () =>
                      Provider.of<UserRepository>(context).signOut(),
                )
              ],
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          profiledata: data,
        ),
      ),
    );
  }
}

class NavigationBar extends StatefulWidget {
  final Profile profiledata;

  const NavigationBar({Key key, this.profiledata}) : super(key: key);
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _buttonIndex = 0;

  setIndex(int index) {
    setState(() {
      _buttonIndex = index;
    });
  }

  isOutlineOrFilled(int ofIndex) {
    if (ofIndex == _buttonIndex) {
      return 'Filled';
    } else {
      return 'Outline';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                onTap: () => setIndex(0),
                child: Image(
                  image: AssetImage(
                      'assets/res_icons/home${isOutlineOrFilled(0)}.png'),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setIndex(1),
                child: Image(
                  image: AssetImage(
                      'assets/res_icons/search${isOutlineOrFilled(1)}.png'),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setIndex(2);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadPage(
                        // Gets data from async snapshot
                        profileData: widget.profiledata,
                      ),
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
                onTap: () => setIndex(3),
                child: Image(
                  image: AssetImage(
                      'assets/res_icons/heart${isOutlineOrFilled(3)}.png'),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setIndex(4),
                child: Image(
                  image: AssetImage(
                      'assets/res_icons/user${isOutlineOrFilled(4)}.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
