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
import 'package:instagram/ui/components/custom_bottomnavbar_item.dart';
import 'package:instagram/ui/components/noback.dart';
import 'package:instagram/ui/screens/profile_page.dart';
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

class _InstagramStateX extends State<Instagram> {
  PageController _pageController;
  ProfileService profileService;
  Widget widgetForBody = HomeView();
  // Change with Profile Page and Back to HomeView()
  int _buttonIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    profileService = ProfileService();
    super.initState();
  }

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
          future: profileService.getProfileSnapshot(_userRepo.user),
          builder:
              (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
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
                    onLongPress: () {
                      _userRepo.signOut();
                    },
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

class _InstagramState extends State<Instagram>
    with SingleTickerProviderStateMixin {
  int _viewIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userRepo = Provider.of<AuthNotifier>(context);
    final data = Provider.of<InfoModel>(context);
    print('[Instagram] ${_userRepo.user}');
    return MaterialApp(
      theme: mainTheme,
      home: NoBack(
        child: Scaffold(
          body: HandleSnapshot(
            future: ProfileService().getProfileSnapshot(_userRepo.user),
            builder:
                (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
              data.info = Profile.fromMap(snapshot.data);
              if (data != null) {
                return Stack(
                  children: <Widget>[
                    new Offstage(
                      offstage: _viewIndex != 0,
                      child: new TickerMode(
                        enabled: _viewIndex == 0,
                        child: new HomeView(),
                      ),
                    ),
                    new Offstage(
                      offstage: _viewIndex != 1,
                      child: new TickerMode(
                        enabled: _viewIndex == 1,
                        child: new MaterialApp(
                          home: new Center(
                            child: Text('Search Page'),
                          ),
                        ),
                      ),
                    ),
                    new Offstage(
                      offstage: _viewIndex != 3,
                      child: new TickerMode(
                        enabled: _viewIndex == 3,
                        child: new MaterialApp(
                          home: new Center(
                            child: Text('Notification Page'),
                          ),
                        ),
                      ),
                    ),
                    new Offstage(
                      offstage: _viewIndex != 4,
                      child: new TickerMode(
                        enabled: _viewIndex == 4,
                        child: new ProfilePage(),
                      ),
                    ),
                  ],
                );
              } else {
                return Text('There\'s an issue');
              }
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _viewIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (indexOfNavBarItem) {
              switch (indexOfNavBarItem) {
                case 0:
                  setState(() {
                    _viewIndex = 0;
                  });
                  break;
                case 1:
                  setState(() {
                    _viewIndex = 1;
                  });
                  break;
                case 2:
                  Navigator.of(context).pushNamed(UploadPostRoute);
                  break;
                case 3:
                  setState(() {
                    _viewIndex = 2;
                  });
                  break;
                case 4:
                  setState(() {
                    _viewIndex = 3;
                  });
                  break;
                default:
              }
            },
            items: [
              icBottomNavBarItem(
                  iconImageAddress: 'assets/res_icons/homeOutline.png',
                  activeIconImageAddress: 'assets/res_icons/homeFilled.png'),
              icBottomNavBarItem(
                  iconImageAddress: 'assets/res_icons/searchOutline.png',
                  activeIconImageAddress: 'assets/res_icons/searchFilled.png'),
              BottomNavigationBarItem(
                title: Container(
                  height: 0,
                ),
                icon: Image(
                  image: AssetImage('assets/res_icons/newPost.png'),
                ),
              ),
              icBottomNavBarItem(
                  iconImageAddress: 'assets/res_icons/heartOutline.png',
                  activeIconImageAddress: 'assets/res_icons/heartFilled.png'),
              icBottomNavBarItem(
                  iconImageAddress: 'assets/res_icons/userOutline.png',
                  activeIconImageAddress: 'assets/res_icons/userFilled.png'),
            ],
          ),
        ),
      ),
    );
  }
}
