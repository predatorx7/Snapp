import 'package:flutter/material.dart';

import '../../models/plain_models/profile.dart';

class ProfilePage extends StatefulWidget {
  final Profile userInfo;

  const ProfilePage({Key key, this.userInfo}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool gridView = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(widget.userInfo.username),
                backgroundColor: Colors.white,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    children: <Widget>[
                      ProfileWidget(),
                      Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                gridView = false;
                              });
                            },
                            child: Icon(Icons.image),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                gridView = true;
                              });
                            },
                            child: Icon(Icons.grid_on),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          new GridView.builder(
            itemCount: widget.userInfo.posts.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (gridView) ? 3 : 1),
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
      ),
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
                Text('${widget.userInfo.posts.length}'),
                Text('Posts'),
              ],
            ),
            // Followers
            Column(
              children: <Widget>[
                Text('${widget.userInfo.followers.length}'),
                Text('Followers'),
              ],
            ),
            // Following
            Column(
              children: <Widget>[
                Text('${widget.userInfo.followers.length}'),
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
