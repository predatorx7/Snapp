import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/ui/components/buttons.dart';
import 'package:provider/provider.dart';

import '../../models/plain_models/profile.dart';

class ProfilePage extends StatefulWidget {
  final Profile userInfo;

  const ProfilePage({Key key, this.userInfo}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin/*<-- This is for the controllers*/ {
  bool gridView = true;
  String url;
  TabController _tabController; // To control switching tabs
  ScrollController _scrollViewController; // To control scrolling
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(widget.userInfo.username),
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
              floating: true,
              pinned: false,
              snap: true,
              // flexibleSpace: FlexibleSpaceBar(
              //   title: ProfileWidget(),
              // ),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.image),
                  ),
                  Tab(
                    icon: Icon(Icons.grid_on),
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
                              crossAxisCount: 1),
                      itemBuilder: (BuildContext context, int index) {
                        url = (widget.userInfo.posts[index]);
                        return new Card(
                          child: new GridTile(
                            footer: new Text(widget.userInfo.posts[index]),
                            child: new Text('Image'
                                // data[index]['image'],
                                ), //just for testing, will fill with image later
                          ),
                        );
                      },
                    ),
                    GridView.builder(
                      itemCount: widget.userInfo.posts.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        String url = (widget.userInfo.posts[index]);
                        return new Card(
                          child: new GridTile(
                            footer: new Text(widget.userInfo.posts[index]),
                            child: new Text('Image'
                                // data[index]['image'],
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
      // OutlineButton(
      //   borderSide: BorderSide(color: Colors.red),
      //   highlightedBorderColor: Colors.redAccent,
      //   textColor: Colors.red,
      //   child: Icon(Icons.vpn_key),
      //   onPressed: () =>
      //       Provider.of<UserRepository>(context).signOut(),
      // )
    );
  }
}

class ProfileWidget extends StatefulWidget {
  final Profile userInfo;

  const ProfileWidget({Key key, this.userInfo}) : super(key: key);
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.userInfo == null) {
      return Text(':(');
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // Profile Photo
            CircleAvatar(
              child: Image.network(widget.userInfo.profileImage),
            ),
            // Posts
            Column(
              children: <Widget>[
                Text('${widget.userInfo.posts.length ?? 0}'),
                Text('Posts'),
              ],
            ),
            // Followers
            Column(
              children: <Widget>[
                Text('${widget.userInfo.followers.length ?? 0}'),
                Text('Followers'),
              ],
            ),
            // Following
            Column(
              children: <Widget>[
                Text('${widget.userInfo.followers.length ?? 0}'),
                Text('Following'),
              ],
            ),
          ],
        ),
        Text(widget.userInfo.fullName),
        Text(widget.userInfo.bio),
        FlatButton(
          child: Text('Edit Profile'),
          onPressed: () {},
        ),
      ],
    );
  }
}
