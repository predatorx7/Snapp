// View with DATA after Authenticated Login
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:instagram/models/view_models/instagram.dart';
import 'package:instagram/ui/components/bottom_navbar.dart';
import 'package:instagram/ui/components/noback.dart';
import 'package:instagram/ui/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'homeView.dart';

class Instagram extends StatefulWidget {
  final FirebaseUser user;
  const Instagram({Key key, this.user}) : super(key: key);
  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> with TickerProviderStateMixin {
  FirebaseDatabase _database = new FirebaseDatabase();
  InfoModel data;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    data = Provider.of<InfoModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[Instagram] User ${widget.user.email}');
    return NoBack(
      child: ScopedModel<InstagramPaginationModel>(
        model: InstagramPaginationModel(),
        child: Scaffold(
            body: StreamBuilder(
              stream: _database
                  .reference()
                  .child("profiles")
                  .orderByChild("email")
                  .equalTo(widget.user.email)
                  .onValue,
              builder:
                  (BuildContext context, AsyncSnapshot<Event> eventSnapshot) {
                switch (eventSnapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          accentColor: Color(actionColor),
                          primaryColor: Colors.white,
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
                      print(
                          '[Instagram] Event Snapshot Error: ${eventSnapshot.error}');
                      data.setInfo(
                          Profile.fromMap(eventSnapshot.data.snapshot));
                      print(
                          '[Instagram] Recieved Profile Data: ${data.info.toJson()}');
                      if (data.info.email != null) {
                        return ScopedModelDescendant<InstagramPaginationModel>(
                            builder: (context, _,
                                InstagramPaginationModel _pageView) {
                          return Stack(
                            children: <Widget>[
                              Visibility(
                                visible: _pageView.viewIndex == 0,
                                child: HomeView(data: data),
                              ),
                              new Offstage(
                                offstage: _pageView.viewIndex != 1,
                                child: new TickerMode(
                                  enabled: _pageView.viewIndex == 1,
                                  child: new MaterialApp(
                                    home: new Center(
                                      child: Text('Search Page'),
                                    ),
                                  ),
                                ),
                              ),
                              new Offstage(
                                offstage: _pageView.viewIndex != 3,
                                child: new TickerMode(
                                  enabled: _pageView.viewIndex == 3,
                                  child: new MaterialApp(
                                    home: new Center(
                                      child: Text('Notification Page'),
                                    ),
                                  ),
                                ),
                              ),
                              new Offstage(
                                offstage: _pageView.viewIndex != 4,
                                child: new TickerMode(
                                  enabled: _pageView.viewIndex == 4,
                                  child: ProfilePage(),
                                ),
                              ),
                            ],
                          );
                        });
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
            bottomNavigationBar:
                ScopedModelDescendant<InstagramPaginationModel>(
              builder: (context, _, InstagramPaginationModel _pageView) {
                return ICBottomNavBar(
                  currentIndex: _pageView.viewIndex,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        _pageView.setIndex(0);
                        break;
                      case 1:
                        _pageView.setIndex(1);
                        break;
                      case 2:
                        Navigator.pushNamed(context, UploadPostRoute);
                        break;
                      case 3:
                        _pageView.setIndex(3);
                        break;
                      case 4:
                        _pageView.setIndex(4);
                        break;
                      default:
                    }
                  },
                  items: <BottomNavigationBarItem>[
                    icBottomNavBarItem(
                      imageAddress: 'assets/res_icons/homeOutline.png',
                      activeImageAddress: 'assets/res_icons/homeFilled.png',
                    ),
                    icBottomNavBarItem(
                      imageAddress: 'assets/res_icons/searchOutline.png',
                      activeImageAddress: 'assets/res_icons/searchFilled.png',
                    ),
                    icBottomNavBarItem(
                      imageAddress: 'assets/res_icons/newPost.png',
                      activeImageAddress: 'assets/res_icons/newPost.png',
                    ),
                    icBottomNavBarItem(
                      imageAddress: 'assets/res_icons/heartOutline.png',
                      activeImageAddress: 'assets/res_icons/heartFilled.png',
                    ),
                    icBottomNavBarItem(
                      imageAddress: 'assets/res_icons/userOutline.png',
                      activeImageAddress: 'assets/res_icons/userFilled.png',
                    ),
                  ],
                );
              },
            )
            /*  
          Container(
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
                        setState(() {});
                        Provider.of<AuthNotifier>(context).signOut();
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
        */
            ),
      ),
    );
  }
}
