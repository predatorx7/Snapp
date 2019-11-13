import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/plain_models/app_notification.dart';
import 'package:instagram/repository/ex_information.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import '../listusers.dart';
import 'visited_post_list.dart';
import 'package:provider/provider.dart';
import '../../../core/adapters/posts.dart';
import '../../../commons/styles.dart';
import '../../../core/services/profile.dart';
import '../../../repository/information.dart';
import '../../../models/plain_models/profile.dart';

class VisitedProfilePage extends StatefulWidget {
  // Profile of this page's owner
  const VisitedProfilePage({Key key}) : super(key: key);
  @override
  _VisitedProfilePageState createState() => _VisitedProfilePageState();
}

class _VisitedProfilePageState extends State<VisitedProfilePage>
    with SingleTickerProviderStateMixin {
  Profile newData;
  bool loaded = false;
  bool gridView = true;
  String url;
  bool firstTime = true;
  ExInfoRepo _data;
  InfoRepo _observer;
  TabController _tabController;
  ScrollController _scrollViewController;
  TextStyle stateful = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle stateless = TextStyle();
  ProfileService profileAdapter = ProfileService();
  FirebaseDatabase _database = FirebaseDatabase();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    _data = Provider.of<ExInfoRepo>(context);
    _observer = Provider.of<InfoRepo>(context, listen: false);
    Future.delayed(
      Duration(seconds: 0),
      () {
        if (firstTime) {
          firstTime = false;
          if (_observer.following.isNotEmpty) {
            for (Profile follower in _observer.following) {
              if (follower.uid == _data.userUID) {
                _data.setFollow(true);
                break;
              }
            }
          }
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  Widget profileWidget(BuildContext context) {
    if (_data.info.email == null) {
      return Text(':(');
    }
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Profile Photo
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () {
                          print('To change profile photo');
                        },
                        child: ICProfileAvatar(
                          profileURL: _data.info.profileImage,
                          size: 45,
                        ),
                      ),
                    ),
                    // Posts
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${_data.posts?.length ?? 0}',
                            style: stateful,
                          ),
                          Text(
                            'Posts',
                          ),
                        ],
                      ),
                    ),
                    // Followers
                    GestureDetector(
                      onTap: () {
                        if (_data.followers.isNotEmpty)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ListUsers(
                                users: _data.followers,
                                title: 'Followers',
                              ),
                            ),
                          );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${_data.followers?.length ?? 0}',
                              style: stateful,
                            ),
                            Text(
                              'Followers',
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Following
                    GestureDetector(
                      onTap: () {
                        if (_data.following.isNotEmpty)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ListUsers(
                                users: _data.following,
                                title: 'Following',
                              ),
                            ),
                          );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${_data.following?.length ?? 0}',
                              style: stateful,
                            ),
                            Text(
                              'Following',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  _data.info.fullName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  _data.info?.bio ?? '',
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 30,
                  child: Visibility(
                    visible: _data.observerFollows,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlineButton(
                            onPressed: () async {
                              await showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                useRootNavigator: true,
                                context: context,
                                builder: (context) {
                                  return BottomSheet(
                                    elevation: 8,
                                    backgroundColor: Colors.transparent,
                                    onClosing: () {
                                      print("Bottom sheet closed");
                                    },
                                    builder: (context) {
                                      return Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(10.0),
                                            topRight:
                                                const Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 4,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Colors.grey[400]),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      Text(_data.info.username),
                                                ),
                                                Divider(),
                                              ],
                                            ),
                                            ListTile(
                                              onTap: _data.isBusy
                                                  ? null
                                                  : () async {
                                                      await _data.doUnFollow(
                                                          _observer.info);
                                                      Navigator.maybePop(
                                                          context);
                                                    },
                                              title: Text(
                                                'Unfollow',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 60,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Following',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                ),
                              ],
                            ),
                            color: Colors.white,
                            highlightedBorderColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: OutlineButton(
                            child: Text(
                              'Message',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            color: Colors.white,
                            highlightedBorderColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onPressed: () {
                              // Follow
                            },
                          ),
                        ),
                      ],
                    ),
                    replacement: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: FlatButton(
                        onPressed: _data.isBusy
                            ? null
                            : () async {
                                // Follow
                                await _data.doFollow(_observer.info);
                                _observer.following.add(_data.info);
                                _observer.notifyChanges();
                                await AppNotification.notify(
                                  AppNotification(
                                    notifyTo: _data.info.uid,
                                    notificationFrom: _observer.info.uid,
                                    event: OnEvent.startedFollowing,
                                  ),
                                );
                              },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        color: Color(actionColor),
                        child: Text(
                          'Follow',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          _data.info.username,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('Hello');
            },
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: RefreshIndicator(
        displacement: 20,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          await _data.refreshAll();
          setState(() {});
        },
        child: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                floating: true,
                pinned: true,
                expandedHeight: _data.heightOfFlexSpace,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: profileWidget(context),
                ),
                actions: <Widget>[Container()],
                bottom: TabBar(
                  indicatorColor: notBlack,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(
                        Icons.grid_on,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ];
          },
          body: Visibility(
            visible: (_data.info != null),
            child: Visibility(
              visible: (_data.posts?.isNotEmpty ?? false),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  RefreshIndicator(
                    displacement: 20,
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 1000));
                      await _data.refreshAll();
                    },
                    child: new GridView.builder(
                      physics: AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemCount: _data.posts.length ?? 0,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return PostAdapters(
                          uid: _data.info.uid,
                          metadata: _data.posts[index],
                          isInGrid: true,
                          database: _database,
                          height: MediaQuery.of(context).size.width,
                          index: index,
                        );
                      },
                    ),
                  ),
                  RefreshIndicator(
                    displacement: 20,
                    onRefresh: () async {
                      await Future.delayed(Duration(milliseconds: 1000));
                      await _data.refreshAll();
                    },
                    child: PostsList(
                      height: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
              replacement: Center(
                child: OutlineButton(
                  onPressed: () async {
                    await _data.refreshAll();
                  },
                  child: Icon(Icons.refresh, color: Colors.black),
                  color: Colors.transparent,
                  highlightedBorderColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
