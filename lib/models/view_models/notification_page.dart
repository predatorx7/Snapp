import 'package:instagram/models/plain_models/app_notification.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationPageModel extends Model {
  List<AppNotification> _notificationList = [];

  List get getNotifications => _notificationList;

  Future<void> fetch(String uid) async {
    _notificationList = await AppNotification.fetchAll(uid);
    notifyListeners();
  }
}
