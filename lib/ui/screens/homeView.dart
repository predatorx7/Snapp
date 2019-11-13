import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/models/plain_models/feed_model.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/models/plain_models/story_model.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/post/feed_post_list.dart';
import 'package:instagram/ui/screens/story/camera.dart';
import 'package:instagram/ui/screens/story/story_view.dart';
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
  InfoRepo _data;
  @override
  void initState() {
    _scrollViewController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoRepo>(context);
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
                  cfeed.fetch(_data.following);
                  story.fetch(_data.following);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    cfeed.fetch(_data.following);
                    story.fetch(_data.following);
                  },
                  child: Builder(builder: (context) {
                    return NestedScrollView(
                      controller: _scrollViewController,
                      headerSliverBuilder:
                          (BuildContext context, bool boxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            expandedHeight: 100,
                            flexibleSpace: FlexibleSpaceBar(
                              background: _StoryView(),
                            ),
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
  InfoRepo _data;
  List<dynamic> followList;
  StoryModel story;
  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoRepo>(context);
    followList = _data.following;
    story = ScopedModel.of<StoryModel>(context);
    switch (story.status) {
      case StoryStatus.idle:
        story.fetch(followList);
        break;
      default:
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (followList.isNotEmpty || followList != null) {
      return Container(
//        height: 65,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 6, right: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ICProfileAvatar(
                          profileURL: _data.info.profileImage,
                          size: 26,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Visibility(
//                           visible: if has stories
                            child: Container(
                              padding: const EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(actionColor),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Your story',
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: story.collection.length,
                itemBuilder: (context, index) {
                  String publisherUID = story.collection.keys.toList()[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StoryView(
                            stories: story.collection[publisherUID],
                            publisherUID: publisherUID,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, left: 6, right: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                            tag: 'aStory',
                            child: ICProfileAvatar(
                              profileOf: publisherUID,
                              size: 26,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              story.collection[publisherUID][0]
                                  .publisherUsername,
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
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
  InfoRepo _data;
  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoRepo>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.following.isNotEmpty) {
      return ScopedModelDescendant<FeedModel>(
        builder: (context, child, cfeed) {
          switch (cfeed.status) {
            case FeedStatus.idle:
              cfeed.fetch(_data.following);
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
