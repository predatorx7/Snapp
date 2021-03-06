import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

enum OnEvent {
  unFollowed,
  startedFollowing,
  likedPost,
  // Not yet supported
  commentedOnYour,
  // Not yet supported
  commentedOnThis,
}

class AppNotification {
  Key key;
  String notifyTo;
  String notificationFrom;
  OnEvent event;
  int time;
  String postKey;
  AppNotification(
      {@required this.notifyTo,
      @required this.notificationFrom,
      this.event,
      this.postKey,
      int atTime}) {
    if (atTime == null) {
      this.time = DateTime.now().millisecondsSinceEpoch;
    } else {
      this.time = atTime;
    }
  }

  static Future<void> notify(AppNotification notification) async {
    DatabaseReference _fRef = FirebaseDatabase.instance
        .reference()
        .child('notifications/for/${notification.notifyTo}/from');
    switch (notification.event) {
      case OnEvent.startedFollowing:
        print('Sending follow notification');
        await _fRef
            .push()
            .child('${notification.notificationFrom}')
            .set({"message": "started following", "time": notification.time});
        break;
      case OnEvent.unFollowed:
        print('Deleting follow notification');
        break;
      case OnEvent.likedPost:
        await _fRef.push().child('${notification.notificationFrom}').set({
          "message": "liked post",
          "time": notification.time,
          "postKey": notification.postKey
        });
        break;
      case OnEvent.commentedOnYour:
        await _fRef.push().child('${notification.notificationFrom}').set({
          "message": "commented on your",
          "time": notification.time,
          "postKey": notification.postKey
        });
        break;
      case OnEvent.commentedOnThis:
        await _fRef.push().child('${notification.notificationFrom}').set({
          "message": "commented on this",
          "time": notification.time,
          "postKey": notification.postKey
        });
        break;
    }
  }

  /// Get all notifications
  static Future<List<AppNotification>> fetchAll(String fetchFor) async {
    List<AppNotification> _notificationList = [];
    Map<String, Map<String, AppNotification>> _notificationMap = {};
    DataSnapshot snap = await FirebaseDatabase.instance
        .reference()
        .child('notifications/for/$fetchFor/from')
        .once();
    if (snap.value != null) {
      for (var i in snap.value.keys.toList()) {
        Map x = snap.value[i];
        String from = x.keys.first;
        OnEvent event;
        // Comment and follow removal missing
        String link;
        switch (x[from]['message']) {
          case "started following":
            event = OnEvent.startedFollowing;
            break;
          case "liked post":
            event = OnEvent.likedPost;
            link = x[from]['postKey'];
            break;
          case "commented on your":
            event = OnEvent.commentedOnYour;
            link = x[from]['postKey'];
            break;
          default:
        }
        _notificationMap.addAll({
          "$from": {
            "${event.toString()}": AppNotification(
              notifyTo: fetchFor,
              notificationFrom: from,
              atTime: x[from]['time'],
              event: event,
              postKey: link ?? null,
            ),
          },
        });
      }
    } else {
      print('No notifications');
    }

    for (Map<String, AppNotification> i in _notificationMap.values.toList()) {
      _notificationList.addAll(i.values);
    }
    return _notificationList;
  }

  String message(String username) {
    String message = "";
    switch (event) {
      case OnEvent.likedPost:
        message = "liked your post.";
        break;
      case OnEvent.startedFollowing:
        message = "started following you.";
        break;
      case OnEvent.commentedOnYour:
        message = "commented on your post";
        break;
      default:
    }
    return "$username $message";
  }
}
