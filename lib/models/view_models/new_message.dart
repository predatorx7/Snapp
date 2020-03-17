import 'package:flutter/foundation.dart';

enum Status {
  fruitful,
  // When showing suggestions
  idle,
  busy,
  searchMode,
}

class NewMessageModel extends ChangeNotifier {
  Status _status = Status.idle;

  Status get status => _status;

  setStatus(Status status) {
    _status = status;
    notifyListeners();
  }
}
