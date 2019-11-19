import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/models/plain_models/app_notification.dart';
import 'package:instagram/models/plain_models/info.dart';
import 'package:instagram/repository/profile.dart';
import 'package:instagram/models/view_models/notification_page.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:timeago/timeago.dart' as timeAgo;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  InfoModel data;
  @override
  void didChangeDependencies() {
    data = Provider.of<InfoModel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<NotificationPageModel>(context).fetch(data.info.uid);
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
              switch (hey.notificationFrom?.isEmpty) {
                case false:
                  return FutureBuilder<DataSnapshot>(
                      future: ProfileService().getProfileSnapshot(hey.notificationFrom),
                      builder: (context, AsyncSnapshot<DataSnapshot> snap) {
                        if (!snap.hasData) return Container();
                        Profile temp = Profile.fromMap(snap.data.value[snap.data.value.keys.first]);
                        return ListTile(
                          onTap: () {
                            if (hey.event == OnEvent.startedFollowing) {
                              Navigator.of(context).pushNamed(
                                  SomeoneProfileRoute,
                                  arguments: temp);
                            }
                          },
                          leading: ICProfileAvatar(
                            profileURL: temp.profileImage,
                          ),
                          title: Text(
                            hey.message(temp.username),
                          ),
                          subtitle: Text(
                            timeAgo.format(
                              DateTime.fromMillisecondsSinceEpoch(hey.time),
                            ),
                          ),
                        );
                      });
                  break;
                case true:
                default:
                  return SizedBox();
                  break;
              }
            },
          );
        },
      ),
    );
  }
}
