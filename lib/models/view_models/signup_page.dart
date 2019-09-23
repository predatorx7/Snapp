import 'package:flutter/cupertino.dart';

enum SignUpStatus { Uninitialized, Started, Running, Checking, Failed, Success }

class SignUpModel with ChangeNotifier {
  SignUpStatus _status = SignUpStatus.Uninitialized;

  SignUpStatus get signUpStatus => _status;

  void setStatus(SignUpStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}
