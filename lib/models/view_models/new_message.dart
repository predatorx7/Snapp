import 'package:flutter/foundation.dart';

enum Status {
  idle,
  busy,
  hasResults,
  none
}
class NewMessageModel extends ChangeNotifier {
  Status _status = Status.idle;

  Status get status => _status;

  set status(Status status) {
    _status = status;
    notifyListeners();
  }

}