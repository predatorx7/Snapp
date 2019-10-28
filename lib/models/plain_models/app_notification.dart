import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

enum OnEvent {
  unFollowed,
  startedFollowing,
}

class AppNotification {
  Key key;
  String notifyTo;
  String notificationFrom;
  OnEvent event;
  int time;
  AppNotification(
      {@required this.notifyTo,
      @required this.notificationFrom,
      @required event})
      : time = DateTime.now().millisecondsSinceEpoch;

  static notify(AppNotification notification) {
    DatabaseReference _fRef = FirebaseDatabase.instance
        .reference()
        .child('notifications/${notification.notifyTo}/from');
    switch (notification.event) {
      case OnEvent.startedFollowing:
        _fRef
            .push()
            .child('${notification.notificationFrom}')
            .set({"message": "started following", "time": notification.time});
        break;
      case OnEvent.unFollowed:
        _fRef
            .push()
            .child('${notification.notificationFrom}')
            .orderByChild("time")
            .equalTo(notification.time)
            .reference()
            .remove();
        break;
    }
  }

  /// Get all notifications
  static Future<List<AppNotification>> fetchAll(String fetchFor) async {
    List<AppNotification> _notificationList = [];
    DataSnapshot snap = await FirebaseDatabase.instance
        .reference()
        .child('notifications/$fetchFor')
        .once();
    if (snap.value != null) {
      for (var i in snap.value.key.toList()){
        print('notification: ${snap.value[i]}');
      }
    }
    return _notificationList;
  }

  String message(){
    return "${this.notificationFrom} started following you";
  }
}
