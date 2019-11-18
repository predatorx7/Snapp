import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/models/view_models/message_all.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/models/view_models/instagram.dart';
import 'package:instagram/models/view_models/notification_page.dart';
import 'package:instagram/ui/components/bottom_navbar.dart';
import 'package:instagram/ui/components/process_indicator.dart';
import 'package:instagram/ui/screens/notification_page.dart';
import 'package:instagram/ui/screens/profile_page.dart';
import 'package:instagram/ui/screens/search_page.dart';
import 'package:instagram/ui/screens/story/capture_story.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'homeView.dart';
import 'messaging/messaging.dart';

class Instagram extends StatefulWidget {
  final FirebaseUser user;
  const Instagram({Key key, this.user}) : super(key: key);
  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState
    extends State<Instagram>{
  InfoRepo data;
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 1, keepPage: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    data = Provider.of<InfoRepo>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MessageAll>(
      model: MessageAll(data.userUID),
      child: ScopedModelDescendant<InstagramPaginationModel>(
          builder: (context, _, InstagramPaginationModel _pageView) {
        return PageView(
          controller: _pageController,
          physics: _pageView.viewIndex != 0
              ? new NeverScrollableScrollPhysics()
              : new PageScrollPhysics(),
          children: <Widget>[
            FutureBuilder(
              future: availableCameras(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CameraDescription>> asyncSnap) {
                if (asyncSnap.hasData) {
                  return TakePictureScreen(
                    // Pass the appropriate camera to the TakePictureScreen widget.
                    camera: asyncSnap.data.first,
                  );
                } else {
                  return Container(
                    color: Colors.black54,
                  );
                }
              },
            ),
            Scaffold(
              body: Visibility(
                visible:
                    (data.profile.uid != null),
                child: Stack(
                  children: <Widget>[
                    Visibility(
                      maintainState: true,
                      visible: _pageView.viewIndex == 0,
                      child: HomeView(
                        pageController: _pageController,
                      ),
                    ),
                    Visibility(
                      maintainState: true,
                      visible: _pageView.viewIndex == 1,
                      child: SearchPage(
                        observer: data.info.uid,
                      ),
                    ),
                    Visibility(
                      maintainState: true,
                      visible: _pageView.viewIndex == 3,
                      child: ScopedModel<NotificationPageModel>(
                        model: NotificationPageModel(),
                        child: NotificationsPage(),
                      ),
                    ),
                    Visibility(
                      maintainState: true,
                      visible: _pageView.viewIndex == 4,
                      child: ProfilePage(),
                    ),
                  ],
                ),
                replacement: Center(
                  child: ICProcessIndicator(size: 34),
                ),
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
                        image: CommonImages.homeOutline,
                        activeImage: CommonImages.homeFilled,
                      ),
                      icBottomNavBarItem(
                        image: CommonImages.searchOutline,
                        activeImage: CommonImages.searchFilled,
                      ),
                      icBottomNavBarItem(
                        image: CommonImages.newPost,
                        activeImage: CommonImages.newPost,
                      ),
                      icBottomNavBarItem(
                        image: CommonImages.heartOutline,
                        activeImage: CommonImages.heartFilled,
                      ),
                      icBottomNavBarItem(
                        image: CommonImages.userOutline,
                        activeImage: CommonImages.userFilled,
                      ),
                    ],
                  );
                },
              ),
            ),
            MessagingPage(
              pageController: _pageController,
            ),
          ],
        );
      }),
    );
  }
}
