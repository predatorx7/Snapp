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
  bool _loaded = false;
  ProfileService profileAdapter = ProfileService();
  ScrollController _scrollViewController;
  InfoModel _data;
  @override
  void initState() {
    _scrollViewController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoModel>(context);
    super.didChangeDependencies();
  }

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
      body: ScopedModel<StoryModel>(
        model: StoryModel(),
        child: ScopedModel<FeedModel>(
          model: FeedModel(),
          child: ScopedModelDescendant<StoryModel>(
              builder: (context, child, story) {
            return ScopedModelDescendant<FeedModel>(
              builder: (context, child, cfeed) {
                if (_loaded) {
                  cfeed.fetch(_data.info.follows);
                  story.fetch(_data.info.follows);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    cfeed.fetch(_data.info.follows);
                    story.fetch(_data.info.follows);
                  },
                  child: Builder(builder: (context) {
                    return NestedScrollView(
                      controller: _scrollViewController,
                      headerSliverBuilder:
                          (BuildContext context, bool boxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            title: _StoryView(),
                          ),
                        ];
                      },
                      body: _FeedView(),
                    );
                  }),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class _StoryView extends StatefulWidget {
  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<_StoryView> {
  bool isListNotEmpty;
  ProfileService profileAdapter = ProfileService();
  InfoModel _data;
  List<dynamic> followList;
  StoryModel story;
  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoModel>(context);
    followList = _data.info.follows;
    story = ScopedModel.of<StoryModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (followList.isNotEmpty || followList != null) {
      return Container(
        height: 50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              ICProfileAvatar(
                profileURL: _data.info.profileImage,
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: story.stories.length,
                itemBuilder: (context, index){
                  return Text(story.stories[index].publisher);
                },
              ),
            ],
          ),
        ),
      );
//      return SliverList(
//        delegate: SliverChildBuilderDelegate((context, index) {
//          return Container(
//            height: 50,
//            child: Row(
//              children: <Widget>[
//                ICProfileAvatar(
//                  profileURL: _data.info.profileImage,
//                ),
////                      ListView(
////                        scrollDirection: Axis.horizontal,
////                        children: <Widget>[
////
////                        ],
////                      ),
//              ],
//            ),
//          );
//        },
////        childCount: ScopedModel.of<StoryModel>(context).stories.length,
//          childCount: story.stories.length,
//        ),
//      );
    } else {
      return SizedBox(
        height: 0,
        width: 0,
      );
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
      return ScopedModelDescendant<FeedModel>(
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
              return Center(
                child: Text(
                  'No posts to show',
                  style: body3Style(),
                ),
              );
            case FeedStatus.fruitful:
              return FeedPostList(
                size: MediaQuery.of(context).size.width,
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
      );
    } else {
      return Center(
        child: Text('You are not following anyone'),
      );
    }
  }
}
