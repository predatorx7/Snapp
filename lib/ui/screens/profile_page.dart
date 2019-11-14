import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/listusers.dart';
import 'package:instagram/ui/screens/post/user_post_list.dart';
import 'package:instagram/ui/screens/story/capture_story.dart';
import 'package:instagram/ui/screens/story/story_view.dart';
import 'package:provider/provider.dart';
import '../../commons/routing_constants.dart';
import '../../core/adapters/posts.dart';
import '../../commons/styles.dart';
import '../../core/services/profile.dart';
import '../../models/plain_models/auth.dart';
import '../../repository/information.dart';
import '../../models/plain_models/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  Profile newData;
  bool loaded = false;
  bool gridView = true;
  String url;
  bool firstTime = true;
  InfoRepo _data;
  TabController _tabController;
  ScrollController _scrollViewController;
  TextStyle stateful = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle stateless = TextStyle();
  ProfileService profileAdapter = ProfileService();
  FirebaseDatabase _database = FirebaseDatabase();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    _data = Provider.of<InfoRepo>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  Widget profileWidget(BuildContext context, Profile data) {
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
                        child: GestureDetector(
                          onTap: () async {
                            if(_data.activeStory.isEmpty){
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
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StoryView(
                                    stories: _data.activeStory,
                                    publisherUID: _data.userUID,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Visibility(
                                visible: _data.activeStory.isNotEmpty,
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image(
                                    image: CommonImages.circleGradientAsset,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              ICProfileAvatar(
                                profileURL: data.profileImage,
                                size: 45,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Visibility(
                                  visible: _data.activeStory.isEmpty,
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
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Posts
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${_data.posts.length ?? 0}',
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
                        if (_data.followers != null ||
                            _data.followers.isNotEmpty)
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
                              '${_data.followers.length ?? 0}',
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
                        if (_data.following != null ||
                            _data.following.isNotEmpty)
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
                              '${_data.following.length ?? 0}',
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
                  data.fullName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  data.bio,
                ),
                SizedBox(
                  height: 15,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: SizedBox(
                    height: 30,
                    child: OutlineButton(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      color: Colors.white,
                      highlightedBorderColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          EditProfileRoute,
                        );
                      },
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
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          _data.info.username,
          style: TextStyle(fontSize: 16),
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: Text(
                      _data.info.username,
                      style: head2Style(),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        onTap: () {
                          /// Popping this Drawer to avoid '_elements.contains(element)' Assertion Error
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Menu(
                                userInfo: _data.info,
                              ),
                            ),
                          );
                        },
                        leading: CommonImages.settingsIcon,
                        title: Text(
                          'Settings',
                          style: actionTitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        displacement: 20,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          await _data.refreshAll();
        },
        child: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.grey[50],
                floating: true,
                pinned: true,
                // snap: true,
                expandedHeight: _data.heightOfFlexSpace,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: profileWidget(context, _data.info),
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
          body: Container(
            color: Colors.grey[50],
            child: Visibility(
              visible: (_data.posts != null),
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
                            uid: _data.userUID,
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
              ),),
            ),
          ),
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final Profile userInfo;
  Menu({Key key, this.userInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BackButtonIcon(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0.0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: notBlack,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () async {
              Provider.of<AuthNotifier>(context).signOut();
//              Navigator.pop(context);
            },
            title: Text(
              'Log out of ${userInfo.username}',
              style: TextStyle(
                color: Color(0xff3897f0),
                //  Color(0xcc3897f0)
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Instagram clone'),
          ),
        ],
      ),
    );
  }
}
