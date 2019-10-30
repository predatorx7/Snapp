import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/posts.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class PostsList extends StatefulWidget {
  final double height;

  const PostsList({Key key, this.height}) : super(key: key);
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> with TickerProviderStateMixin {
  String uid;
  List postList;
  double heartSize = 100;
  InfoModel _data;
  bool firstTime = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoModel>(context);
    if (firstTime) {
      uid = _data.info.uid;
      postList = _data.info.posts;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: _data.info.posts.length ?? 0,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future: FirebaseDatabase.instance
              .reference()
              .child('posts/$uid')
              .orderByChild("creationTime")
              .equalTo(postList[index])
              .once(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              if (!snapshot.hasData) {
                return Container();
              } else {
                Post metadata = Post.fromMap(snapshot.data);
                return ScopedModel<PostsListModel>(
                  model: PostsListModel(),
                  child: new Material(
                    child: ScopedModelDescendant<PostsListModel>(
                      builder: (context, _, view) {
                        view.setliked(metadata.likes.contains(_data.info.uid));
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, top: 4, bottom: 4),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage:
                                        _data.info.profileImage.isNotEmpty
                                            ? Image.network(
                                                _data.info.profileImage,
                                              ).image
                                            : null,
                                    child: Visibility(
                                      visible: _data.info.profileImage.isEmpty,
                                      child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CommonImages.profilePic2,
                                      ),
                                    ),
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
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    onTap: () {
                                                      print('Edit');
                                                      Navigator.pop(context);
                                                    },
                                                    title: Text(
                                                      'Edit',
                                                      style:
                                                          actionTitle2Style(),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    onTap: () async {
                                                      var publisher = metadata
                                                              .publisher,
                                                          postKey =
                                                              metadata.postKey,
                                                          creationTime =
                                                              metadata
                                                                  .creationTime;
                                                      var database =
                                                          FirebaseDatabase()
                                                              .reference();
                                                      database
                                                          .child(
                                                              'posts/$publisher/$postKey')
                                                          .remove();
                                                      database
                                                          .child(
                                                              'profiles/$publisher/posts')
                                                          .once()
                                                          .then((DataSnapshot
                                                              snapshot) {
                                                        Map postsList =
                                                            snapshot.value;
                                                        postsList.forEach(
                                                            (key, value) {
                                                          if (value ==
                                                              creationTime) {
                                                            database
                                                                .child(
                                                                    'profiles/$publisher/posts/$key')
                                                                .remove();
                                                          }
                                                        });
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    title: Text(
                                                      'Delete',
                                                      style:
                                                          actionTitle2Style(),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    onTap: () {
                                                      print(
                                                          'Turn Off Commenting');
                                                      Navigator.pop(context);
                                                    },
                                                    title: Text(
                                                      'Turn Off Commenting',
                                                      style:
                                                          actionTitle2Style(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.more_vert,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onDoubleTap: () async {
                                  // Toggle heart animation
                                  view.doAnimation();
                                  if (!view.liked) {
                                    await PostService.doLike(
                                        _data.info, metadata);
                                    metadata.likes.add(_data.info.uid);
                                    view.setliked(true);
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
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  accentColor: Colors.grey[300],
                                                  primaryColor: Colors.grey,
                                                ),
                                                child: SizedBox(
                                                  height: 28,
                                                  width: 28,
                                                  child:
                                                      new CircularProgressIndicator(
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
                                          height: widget.height,
                                          width: widget.height,
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
                                                duration: new Duration(
                                                    milliseconds: 900),
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
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        if (!view.liked) {
                                          view.setliked(true);
                                          await PostService.doLike(
                                              _data.info, metadata);
                                          metadata.likes.add(_data.info.uid);
                                        } else {
                                          await PostService.unLike(
                                              _data.info, metadata);
                                          metadata.likes.remove(_data.info.uid);
                                          view.setliked(false);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Visibility(
                                          visible: view.liked,
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
                                        padding: const EdgeInsets.all(6),
                                        child: RotationTransition(
                                          turns: new AlwaysStoppedAnimation(
                                              -45 / 360),
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
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 4.0),
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
                                  padding:
                                      const EdgeInsets.only(top: 2, bottom: 12),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 4.0),
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
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}

class PostsListModel extends Model {
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
