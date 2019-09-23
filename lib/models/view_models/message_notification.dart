import 'package:flutter/cupertino.dart';

class MessageNotificationModel with ChangeNotifier {
  int _messages = 0;

  int getMessageCount() => _messages;

  int setMessageCount(int count) => _messages = count;

  void messageCounter(int messageCount) {
    _messages = messageCount;
    notifyListeners();
  }
}
