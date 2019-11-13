import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:provider/provider.dart';

class ListUsers extends StatefulWidget {
  final List<Profile> users;
  final String title;
  const ListUsers({Key key, this.users, this.title}) : super(key: key);
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  InfoRepo observer;
  @override
  void didChangeDependencies() {
    observer = Provider.of<InfoRepo>(context);
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.title, style: actionTitleStyle()),
      ),
      body: ListView.builder(
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          Profile key = widget.users[index];
          return ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(SomeoneProfileRoute, arguments: key);
            },
            leading: ICProfileAvatar(
              profileURL: key.profileImage,
            ),
            title: Text(
              key.username,
              style: body3Style(),
            ),
          );
        },
      ),
    );
  }
}
