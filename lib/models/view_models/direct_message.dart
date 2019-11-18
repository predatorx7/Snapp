import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/core/services/messaging.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/models/plain_models/profile.dart';

enum Status { idle, busy, sending, loading, error }

class DirectMessageModel extends ChangeNotifier {
  String chatId;
  Status status = Status.idle;
  String thisUser;
  String thatUser;
  Profile thatUserProfile;

  bool get isSending => status == Status.sending ? true : false;

  DirectMessageModel.initialize({
    @required this.thisUser,
    @required this.thatUser,
  }) {
    status = Status.loading;
    notifyListeners();
    Future.delayed(Duration(seconds: 10), () {
      status = Status.error;
      notifyListeners();
    });
    ProfileService().getProfileSnapshot(thatUser).then((DataSnapshot onValue) {
      if (onValue.value != null)
        thatUserProfile = Profile.fromDataSnapshot(onValue);
      _checkStatus();
    });
    MessagingService().getChatID(thisUser, thatUser).then((String value) {
      if (value != null) chatId = value;
      _checkStatus();
    });
  }

  /// ReInitialize with this on Initialization Error
  DirectMessageModel.reInitialize() {
    status = Status.loading;
    notifyListeners();
    Future.delayed(Duration(seconds: 10), () {
      status = Status.error;
      notifyListeners();
    });
    if (thatUserProfile?.username == null)
      ProfileService()
          .getProfileSnapshot(thatUser)
          .then((DataSnapshot onValue) {
        if (onValue.value != null)
          thatUserProfile = Profile.fromDataSnapshot(onValue);
        _checkStatus();
      });
    if (chatId == null)
      MessagingService().getChatID(thisUser, thatUser).then((String value) {
        if (value != null) chatId = value;
        _checkStatus();
      });
    _checkStatus();
  }
  _checkStatus() {
    if (chatId?.isNotEmpty == true && thatUserProfile?.username != null) {
      status = Status.idle;
      notifyListeners();
    }
  }

  void setStatus(Status status){
    this.status = status;
   notifyListeners();
  }
}
