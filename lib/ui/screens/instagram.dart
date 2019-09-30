// View with DATA after Authenticated Login
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/plain_models/auth.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:instagram/ui/components/noback.dart';
import 'package:instagram/ui/screens/profile_page.dart';
import '../../ui/components/handle_snapshot.dart';
import '../../core/services/profile.dart';
import 'package:provider/provider.dart';

import 'homeView.dart';

class Instagram extends StatefulWidget {
  const Instagram({Key key}) : super(key: key);
  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramStateX extends State<Instagram> {
  PageController _pageController;
  ProfileService profileService;
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
            // data.info = Profile.fromMap(snapshot.data);
            if (data.info.email != null) {
              // return widgetForBody;
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

class _InstagramState extends State<Instagram> with TickerProviderStateMixin {
  FirebaseDatabase _database = new FirebaseDatabase();
  int _viewIndex = 0;
  AuthNotifier _userRepo;
  InfoModel data;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userRepo = Provider.of<AuthNotifier>(context);
    data = Provider.of<InfoModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _userRepo.dispose();
    data.dispose();
    super.dispose();
  }

  _setIndex(int index) {
    setState(() {
      _viewIndex = index;
    });
  }

  _isOutlineOrFilled(int ofIndex) {
    if (ofIndex == _viewIndex) {
      return 'Filled';
    } else {
      return 'Outline';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[Instagram] User ${_userRepo.user}');
    return MaterialApp(
      theme: mainTheme,
      home: NoBack(
        child: Scaffold(
          body: StreamBuilder(
            stream: _database
                .reference()
                .child("profiles")
                .orderByChild("email")
                .equalTo(_userRepo.user.email)
                .onValue,
            builder:
                (BuildContext context, AsyncSnapshot<Event> eventSnapshot) {
              switch (eventSnapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        accentColor: Colors.white,
                        primaryColor: Colors.blue,
                      ),
                      child: SizedBox(
                        height: 27,
                        width: 27,
                        child: new CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  );
                  break;
                default:
                  if (!eventSnapshot.hasData) {
                    return Center(
                      child: Text(':('),
                    );
                  } else {
                    data.setInfo(Profile.fromMap(eventSnapshot.data.snapshot));
                    print(
                        '[Instagram] Recieved Profile Data: ${data.info.toJson()}');
                    if (data.info.email != null) {
                      return Stack(
                        children: <Widget>[
                          Visibility(
                            visible: _viewIndex == 0,
                            child: HomeView(data: data),
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
                              child: ProfilePage(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      data.setInfo(
                          Profile.fromMap(eventSnapshot.data.snapshot));
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('There\'s an issue'),
                          Text(Profile.fromMap(eventSnapshot.data.snapshot)
                              .toJson()
                              .toString()),
                          Text(
                            data.info.toJson().toString(),
                          )
                        ],
                      );
                    }
                  }
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
      ),
    );
  }
}
