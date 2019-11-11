import 'dart:math';

import 'package:flutter/widgets.dart';

class Transactions extends ChangeNotifier {
  bool _isLocked = false;
  int _tid;

  /// Is transaction locked?
  bool get isLocked => _isLocked;

  int acquireLock() {
    if (!_isLocked) {
      _isLocked = true;
      int randomNum(int min, int max) => min + Random().nextInt(max - min);
      int x;
      while (true) {
        x = randomNum(0, 100);
        if (x != _tid) break;
      }
      _tid = x;
      notifyListeners();
      return _tid;
    } else {
      print('Cannot acquire lock. Another transaction is in process.');
      return -1;
    }
  }

  bool releaseLock(int tid) {
    if (_tid == tid && _isLocked == true) {
      _isLocked = false;
      _tid = null;
      notifyListeners();
      print('Transaction lock released!');
      return true;
    } else {
      print('Incorrect PID');
      return false;
    }
  }
}