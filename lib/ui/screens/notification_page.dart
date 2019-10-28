import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/models/plain_models/app_notification.dart';
import 'package:instagram/models/plain_models/information.dart';
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
  InfoModel data;
  NotificationPageModel view;
  @override
  void didChangeDependencies() {
    data = Provider.of<InfoModel>(context, listen: false);
    view = ScopedModel.of<NotificationPageModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 0), () {
      view.fetch(data.info.uid);
    });
    return Scaffold(
      body: ListView.builder(
        itemCount: view.getNotifications.length,
        itemBuilder: (context, index) {
          if (view.getNotifications.isEmpty) {
            return Container();
          }
          AppNotification hey = view.getNotifications[index];
          return ListTile(
            onTap: (){
              Navigator.of(context)
                  .pushNamed(SomeoneProfileRoute, arguments: hey.notificationFrom);
            },
            leading: ICProfileAvatar(
              profileOf: hey.notificationFrom,
            ),
            title: Text(
              hey.message(),
            ),
            subtitle: Text(
              timeago.format(
                DateTime.fromMillisecondsSinceEpoch(hey.time),
              ),
            ),
          );
        },
      ),
    );
  }
}
