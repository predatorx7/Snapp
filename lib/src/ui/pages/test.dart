// // if (data == null) {
// //       Future.delayed(Duration.zero, () {
// //         setState(() {});
// //       });
// //       return Text(':(');
// //     }

//  WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           profileAdapter
//         .getProfileSnapshot(userRepo.user)
//         .then((DataSnapshot snapshot) {
//       newData = Profile.fromMap(snapshot.value);
//       print('New Data: ${newData.toJson()}');
//       if (data.toJson() != newData.toJson()) {
//         heightOfFlexSpace = flexibleSpaceHeight.withText(text: data.bio);
//         print('Height of flex: $heightOfFlexSpace');
//         if (mounted)
//           setState(() {
//             data = newData;
//           });
//       }
//     });
//         }
//       });

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/src/core/services/handle_snapshot.dart';
import 'package:instagram/src/core/services/profile_adapter.dart';
import 'package:instagram/src/core/utils/styles.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/ui/components/refresher.dart';
import 'package:instagram/src/ui/components/restart_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/plain_models/profile.dart';

class ProfilePage extends StatefulWidget {
  final Profile userInfo;

  const ProfilePage({Key key, this.userInfo}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin/*<-- This is for the controllers*/ {
  Profile data;
  bool loaded = false;
  bool gridView = true;
  String url;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TabController _tabController; // To control switching tabs
  ScrollController _scrollViewController; // To control scrolling
  TextStyle stateful = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle stateless = TextStyle();
  double heightOfFlexSpace;
  ProfileAdapter profileAdapter = ProfileAdapter();
  @override
  void initState() {
    super.initState();
    data = data;
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollViewController.dispose();
  }

  Widget profileWidget(BuildContext context, Profile data) {
    if (widget.userInfo == null) {
      return Text(':(');
    }
    print(data.bio);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
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
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey[200],
                        child: data.profileImage.isNotEmpty
                            ? Image.network(
                                data.profileImage,
                              )
                            : Image(
                                fit: BoxFit.contain,
                                image: AssetImage('assets/icon/ic_profile.png'),
                              ),
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
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: OutlineButton(
              child: Text(
                'Edit Profile',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return HandleSnapshot(
      future: profileAdapter.getProfileSnapshot(userRepo.user),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        loaded = true;
        data = Profile.fromMap(snapshot.data);
        heightOfFlexSpace = flexibleSpaceHeight.withText(text: data.bio);
        print('Height of flex: $heightOfFlexSpace');
        if (data == null) {
          return Text('There\'s an issue');
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                data.username,
                style: TextStyle(fontSize: 16),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    print('menu');
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Menu(
                          userInfo: widget.userInfo,
                        ),
                      ),
                    );
                  },
                )
              ],
              backgroundColor: Colors.white,
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
                    snap: true,
                    expandedHeight: heightOfFlexSpace,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: profileWidget(context, data),
                    ),
                    bottom: TabBar(
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
                visible: (widget.userInfo != null),
                child: (widget.userInfo.posts.isNotEmpty)
                    ? TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          new GridView.builder(
                            physics: AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            itemCount: widget.userInfo.posts.length ?? 0,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              url = (widget.userInfo.posts[index]);
                              return new Card(
                                child: new GridTile(
                                  footer: Text('Caption'),
                                  child: Container(
                                    child: new Image.network(
                                      widget.userInfo.posts[index],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ), //just for testing, will fill with image later
                                ),
                              );
                            },
                          ),
                          GridView.builder(
                            itemCount: widget.userInfo.posts.length,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (BuildContext context, int index) {
                              String url = (widget.userInfo.posts[index]);
                              return new Card(
                                child: new GridTile(
                                  footer: Text('Caption'),
                                  child: new Image.network(
                                    widget.userInfo.posts[index],
                                    fit: BoxFit.fitWidth,
                                  ), //just for testing, will fill with image later
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            ),
          );
        }
      },
    );
  }
}

class Menu extends StatelessWidget {
  final Profile userInfo;

  const Menu({Key key, this.userInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () => Provider.of<UserRepository>(context).signOut(),
            title: Text(
              'Log out of ${userInfo.username}',
              style: TextStyle(
                color: Color(0xff3897f0),
                //  Color(0xcc3897f0)
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
    );
  }
}
