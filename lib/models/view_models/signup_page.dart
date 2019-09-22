import 'package:flutter/cupertino.dart';

enum SignUpStatus { Uninitialized, Started, Running, Checking, Failed, Success }

class SignUpModel with ChangeNotifier {
  SignUpStatus _status = SignUpStatus.Uninitialized;
  String _email;

  String get email => _email;

  set email(String email) {
    _email = email;
  }

  SignUpStatus get signUpStatus => _status;

  void setStatus(SignUpStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}
