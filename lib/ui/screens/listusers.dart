import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:instagram/models/plain_models/user_list.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ListUsers extends StatefulWidget {
  final List users;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.title, style: actionTitleStyle()),
      ),
      body: ScopedModel<UserListModel>(
        model: UserListModel(widget.users),
        child:
            ScopedModelDescendant<UserListModel>(builder: (context, _, view) {
          return ListView.builder(
            itemCount: view.results.length,
            itemBuilder: (context, index) {
              if (view.results.isEmpty || view.results == null)
                return Container();
              String pKey = view.results.keys.toList()[index];
              Profile key = view.results[pKey];
              return ListTile(
                onTap: () {
                  if (observer.info.uid == key.uid) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  } else {
                    Navigator.of(context)
                        .pushNamed(SomeoneProfileRoute, arguments: key);
                  }
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
          );
        }),
      ),
    );
    ;
  }
}
