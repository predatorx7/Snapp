import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/models/plain_models/feed_model.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/story_model.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/post/feed_post_list.dart';
import 'package:instagram/ui/screens/story/camera.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/view_models/message_notification.dart';
import 'package:provider/provider.dart';

import 'messaging/messaging.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool loaded = false;
  ProfileService profileAdapter = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  List<CameraDescription> camera = await availableCameras();
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TakePictureScreen(
                        // Pass the appropriate camera to the TakePictureScreen widget.
                        camera: camera.first,
                      ),
                    ),
                  );
                },
                child: CommonImages.cameraOutline,
              ),
              SizedBox(
                width: 10,
              ),
              CommonImages.logo,
            ],
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MessagingPage(),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  child: CommonImages.directOutline2,
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
      body:  _FeedView(),
//      Column(
//        children: <Widget>[
//          _StoryView(),
//          _FeedView(),
//        ],
//      ),
    );
  }
}

class _StoryView extends StatefulWidget {
  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<_FeedView> {
  bool isListNotEmpty;
  ProfileService profileAdapter = ProfileService();
  InfoModel _data;
  List<dynamic> followList;
  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoModel>(context);
    followList = _data.info.follows;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (followList.isNotEmpty || followList != null) {
      return ScopedModel<StoryModel>(
        model: StoryModel(),
        child: ScopedModelDescendant<StoryModel>(
          builder: (context, child, story) {
            print('List of followers: ${followList.toString()}');
            switch (story.status) {
              case StoryStatus.idle:
                story.fetch(followList);
                return Center(
                  child: Text('Wait'),
                );
              case StoryStatus.busy:
                return Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: icProcessIndicator(context),
                  ),
                );
              case StoryStatus.nothing:
                return RefreshIndicator(
                  onRefresh: () async {
                    await story.fetch(followList);
                  },
                  child: Center(
                    child: Text(
                      'No posts to show',
                      style: body3Style(),
                    ),
                  ),
                );
              case StoryStatus.fruitful:
                return RefreshIndicator(
                  onRefresh: () async {
                    await story.fetch(followList);
                  },
                  child: Row(
                    children: <Widget>[
                      ICProfileAvatar(profileURL: _data.info.profileImage,),
//                      ListView(
//                        scrollDirection: Axis.horizontal,
//                        children: <Widget>[
//
//                        ],
//                      ),
                    ],
                  ),
                );
              default:
                return child;
            }
          },
          child: Center(
            child: Text(
              'There\'s an issue',
              style: body3Style(),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

class _FeedView extends StatefulWidget {
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> {
  bool isListNotEmpty;
  ProfileService profileAdapter = ProfileService();
  InfoModel _data;
  List<dynamic> followList;
  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoModel>(context);
    followList = _data.info.follows;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (followList.isNotEmpty) {
      return ScopedModel<FeedModel>(
        model: FeedModel(),
        child: ScopedModelDescendant<FeedModel>(
          builder: (context, child, cfeed) {
            print('List of followers: ${followList.toString()}');
            switch (cfeed.status) {
              case FeedStatus.idle:
                cfeed.fetch(followList);
                return Center(
                  child: Text('Wait'),
                );
              case FeedStatus.busy:
                return Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    child: icProcessIndicator(context),
                  ),
                );
              case FeedStatus.nothing:
                return RefreshIndicator(
                  onRefresh: () async {
                    await cfeed.fetch(followList);
                  },
                  child: Center(
                    child: Text(
                      'No posts to show',
                      style: body3Style(),
                    ),
                  ),
                );
              case FeedStatus.fruitful:
                return RefreshIndicator(
                  onRefresh: () async {
                    await cfeed.fetch(followList);
                  },
                  child: FeedPostList(
                    size: MediaQuery.of(context).size.width,
                  ),
                );
              default:
                return child;
            }
          },
          child: Center(
            child: Text(
              'There\'s an issue',
              style: body3Style(),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Text('You are not following anyone'),
      );
    }
  }
}
