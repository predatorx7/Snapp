import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/post_list.dart';
import 'package:provider/provider.dart';
import '../../commons/routing_constants.dart';
import '../../core/adapters/posts.dart';
import '../../commons/styles.dart';
import '../../core/services/profile.dart';
import '../../models/plain_models/auth.dart';
import '../../models/plain_models/information.dart';
import '../../models/plain_models/profile.dart';
import 'test.dart';

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
  InfoModel _data;
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
    _data = Provider.of<InfoModel>(context);
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
    print(data.bio);
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
                        child: Stack(
                          children: <Widget>[
                            // CircleAvatar(
                            //   radius: 45,
                            //   backgroundColor: Colors.grey[200],
                            //   backgroundImage: data.profileImage.isNotEmpty
                            //       ? NetworkImage(
                            //           data.profileImage,
                            //         )
                            //       : CommonImages.profilePic1.image,
                            // ),
                            ICProfileAvatar(
                              // database: FirebaseDatabase.instance,
                              // profileOf: data.uid,
                              profileURL: data.profileImage,
                              size: 45,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
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
                          ],
                        ),
                      ),
                    ),
                    // Posts
                    Column(
                      children: <Widget>[
                        Text(
                          '${data.posts.length ?? 0}',
                          style: stateful,
                        ),
                        Text(
                          'Posts',
                        ),
                      ],
                    ),
                    // Followers
                    Column(
                      children: <Widget>[
                        Text(
                          '${data.followers.length ?? 0}',
                          style: stateful,
                        ),
                        Text(
                          'Followers',
                        ),
                      ],
                    ),
                    // Following
                    Column(
                      children: <Widget>[
                        Text(
                          '${data.followers.length ?? 0}',
                          style: stateful,
                        ),
                        Text(
                          'Following',
                        ),
                      ],
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
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      color: Colors.white,
                      highlightedBorderColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
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
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          _data.info.username,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.white,
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
                  // ListTile(
                  //   onTap: () {},
                  //   title: Text("Ttem 1"),
                  //   trailing: Icon(Icons.arrow_forward),
                  // ),
                  // ListTile(
                  //   title: Text("Item 2"),
                  //   trailing: Icon(Icons.arrow_forward),
                  // ),
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
                          /// Poping this Drawer to avoid '_elements.contains(element)' Assertion Error
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
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
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
        body: Visibility(
          visible: (_data.info != null),
          child: (_data.info.posts.isNotEmpty)
              ? TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    new GridView.builder(
                      physics: AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemCount: _data.info.posts.length ?? 0,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return PostAdapters(
                          uid: _data.info.uid,
                          creationTime: _data.info.posts[index],
                          isInGrid: true,
                          database: _database,
                          height: MediaQuery.of(context).size.width,
                          index: index,
                        );
                      },
                    ),
                    PostsList(
                      data: _data,
                      database: _database,
                      height: MediaQuery.of(context).size.width,
                    ),
                  ],
                )
              : SizedBox(),
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
              Navigator.pop(context);
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
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TestPage(),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('Instagram clone'),
            ),
          ),
        ],
      ),
    );
  }
}
