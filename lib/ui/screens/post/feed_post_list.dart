import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/posts.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/models/plain_models/app_notification.dart';
import 'package:instagram/models/plain_models/feed_model.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class FeedPostList extends StatefulWidget {
  final double size;
  const FeedPostList({Key key, this.size}) : super(key: key);
  @override
  _FeedPostListState createState() => _FeedPostListState();
}

class _FeedPostListState extends State<FeedPostList>
    with TickerProviderStateMixin {
  FeedModel cFeed;
  InfoModel _observer;
  @override
  void didChangeDependencies() {
    cFeed = ScopedModel.of<FeedModel>(context);
    _observer = Provider.of<InfoModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: cFeed.posts.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (BuildContext context, int index) {
        Post metadata = cFeed.posts[index];
        bool postLiked = metadata.likes.contains(_observer.info.uid);
        return ScopedModel<SubPostModel>(
          model: SubPostModel(),
          child: new Material(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4, bottom: 4),
                  child: Row(
                    children: <Widget>[
                      ICProfileAvatar(
                        profileOf: metadata.publisher,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          metadata.publisherUsername,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: notBlack),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        'Share to...',
                                        style: actionTitle2Style(),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () async {
                                        await ProfileService().doUnFollow(
                                            _observer.info, metadata.publisher);
                                        _observer.info.follows
                                            .remove(metadata.publisher);
                                        _observer.shout();
                                        Navigator.maybePop(context);
                                      },
                                      title: Text(
                                        'Unfollow',
                                        style: actionTitle2Style(),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        print('Mute');
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        'Mute',
                                        style: actionTitle2Style(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.more_vert, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ScopedModelDescendant<SubPostModel>(
                      builder: (context, _, view) {
                    if (postLiked) {
                      view.setliked(true);
                    } else {
                      view.setliked(false);
                    }
                    return GestureDetector(
                      onDoubleTap: () async {
                        // Toggle heart animation
                        view.doAnimation();
                        if (!postLiked) {
                          await PostService.doLike(_observer.info, metadata);
                          AppNotification(
                            notifyTo: metadata.publisher,
                            notificationFrom: _observer.info.uid,
                            event: OnEvent.likedPost,
                            postKey: metadata.postKey ?? '',
                          );
                          metadata.likes.add(_observer.info.uid);
                          setState(() {
                            postLiked = true;
                          });
                        }
                      },
                      child: Stack(
                        children: <Widget>[
                          GridTile(
                            child: Container(
                              color: Colors.grey[200],
                              child: Image.network(
                                metadata.imageURL,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        accentColor: Colors.grey[300],
                                        primaryColor: Colors.grey,
                                      ),
                                      child: SizedBox(
                                        height: 28,
                                        width: 28,
                                        child: new CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                height: widget.size,
                                width: widget.size,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              switch (view.showHeart) {
                                case true:
                                  return Opacity(
                                    opacity: 0.5,
                                    child: AnimatedSize(
                                      vsync: this,
                                      alignment: Alignment.center,
                                      curve: Curves.easeIn,
                                      duration: new Duration(milliseconds: 900),
                                      child: Align(
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.grey[300],
                                          size: view.size,
                                        ),
                                      ),
                                    ),
                                  );
                                  break;
                                default:
                                  return SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                ScopedModelDescendant<SubPostModel>(
                  builder: (context, _, view) {
                    return Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                if (!postLiked) {
                                  view.setliked(true);
                                  await PostService.doLike(
                                      _observer.info, metadata);
                                  await AppNotification.notify(
                                    AppNotification(
                                      notifyTo: metadata.publisher,
                                      notificationFrom: _observer.info.uid,
                                      event: OnEvent.likedPost,
                                      postKey: metadata.postKey ?? '',
                                    ),
                                  );
                                  metadata.likes.add(_observer.info.uid);
                                  setState(() {
                                    postLiked = true;
                                  });
                                } else {
                                  await PostService.unLike(
                                      _observer.info, metadata);
                                  metadata.likes.remove(_observer.info.uid);
                                  setState(() {
                                    postLiked = false;
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Visibility(
                                  visible: postLiked,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red[400],
                                    size: 30,
                                  ),
                                  replacement: Icon(
                                    Icons.favorite_border,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('pressed comment');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.chat_bubble_outline,
                                  size: 30,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('pressed send');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: RotationTransition(
                                  turns: new AlwaysStoppedAnimation(-45 / 360),
                                  child: new Icon(
                                    OMIcons.send,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 4.0),
                                child: Text(
                                  '${metadata.likes.length} likes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: notBlack,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 12),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 4.0),
                                child: Text(
                                  metadata.publisherUsername,
                                  style: bodyStyle(),
                                ),
                              ),
                              Text(metadata.description),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SubPostModel extends Model {
  bool _showHeart = false;

  bool get showHeart => _showHeart;

  setShowHeart(bool showHeart) {
    _showHeart = showHeart;
    notifyListeners();
  }

  bool _liked = false;

  bool get liked => _liked;

  setliked(bool liked) {
    _liked = liked;
    notifyListeners();
  }

  double _size = 120;

  double get size => _size;

  setSize(double size) {
    _size = size;
    notifyListeners();
  }

  doAnimation() async {
    setShowHeart(true);
    setliked(true);
    Future.delayed(Duration(milliseconds: 900), () {
      setShowHeart(false);
    });
    Future.delayed(Duration(milliseconds: 150), () {
      setSize(130);
    });
    Future.delayed(Duration(milliseconds: 250), () {
      setSize(140);
    });
    Future.delayed(Duration(milliseconds: 500), () {
      setSize(120);
    });
  }
}
