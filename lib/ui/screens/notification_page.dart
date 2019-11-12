import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/plain_models/app_notification.dart';
import 'package:instagram/repository/information.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:instagram/models/view_models/notification_page.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  InfoRepo data;
  @override
  void didChangeDependencies() {
    data = Provider.of<InfoRepo>(context, listen: false);
    ScopedModel.of<NotificationPageModel>(context).fetch(data.info.uid);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ScopedModelDescendant<NotificationPageModel>(
          builder: (context, _, view) {
        return ListView.builder(
          itemCount: view.getNotifications.length,
          itemBuilder: (context, index) {
            AppNotification hey = view.getNotifications[index];
            return FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child('profiles')
                    .orderByChild("uid")
                    .equalTo(hey.notificationFrom)
                    .once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snap) {
                  if (!snap.hasData) return Container();
                  Profile temp = Profile.fromMap(snap.data);
                  return ListTile(
                    onTap: () {
                      if (hey.event == OnEvent.startedFollowing) {
                        Navigator.of(context)
                            .pushNamed(SomeoneProfileRoute, arguments: temp);
                      }
                    },
                    leading: ICProfileAvatar(
                      profileURL: temp.profileImage,
                    ),
                    title: Text(
                      hey.message(hey.event, temp.username),
                    ),
                    subtitle: Text(
                      timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(hey.time),
                      ),
                    ),
                  );
                });
          },
        );
      }),
    );
  }
}
