import 'dart:math';

import 'package:flutter/widgets.dart';

/// Transactions can be used when performing tasks where state update could repeat a process.
/// Use Transactions to only allow a single instance to complete that process and reject others (state issues).
/// ! This is a workaround for state issues
class Transactions extends ChangeNotifier {
  bool _isLocked = false;
  int _tid;

  /// Is transaction locked?
  bool get isLocked => _isLocked;

  perform(Function task){
    if(!this.isLocked){
      int key = this.acquireLock();
      task();
      this.releaseLock(key);
    }
  }

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
      print('Transaction lock released!');
      return true;
    } else {
      print('Incorrect PID');
      return false;
    }
  }
}