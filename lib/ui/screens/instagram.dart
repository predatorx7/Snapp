// View with DATA after Authenticated Login
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/plain_models/auth.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/profile.dart';
import '../../ui/components/handle_snapshot.dart';
import '../../core/services/profile.dart';
import 'package:provider/provider.dart';

import 'homeView.dart';

class Instagram extends StatefulWidget {
  final FirebaseUser user;

  const Instagram({Key key, this.user}) : super(key: key);
  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  PageController _pageController;
  ProfileService profileService = ProfileService();
  Widget widgetForBody = HomeView();
  // Change with Profile Page and Back to HomeView()
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
  Widget build(BuildContext context) {
    final data = Provider.of<InfoModel>(context);
    final _userRepo = Provider.of<AuthNotifier>(context);
    return MaterialApp(
      theme: mainTheme,
      home: Scaffold(
        body: HandleSnapshot(
          future: Stream.fromFuture(
            profileService.getProfileSnapshot(_userRepo.user),
          ),
          builder:
              (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
            loaded = true;
            data.info = Profile.fromMap(snapshot.data);
            if (data != null) {
              return widgetForBody;
            } else {
              return Text('There\'s an issue');
            }
          },
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
                      Navigator.pushNamed(context, UploadPostRoute);
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
                      Navigator.pushNamed(context, ProfilePageRoute);
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
    _pageController.dispose();
    super.dispose();
  }
}
