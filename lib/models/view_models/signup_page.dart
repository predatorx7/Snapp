import 'package:flutter/cupertino.dart';

enum SignUpStatus { Uninitialized, Started, Running, Checking, Failed, Success }

class SignUpViewModel with ChangeNotifier {
  SignUpStatus _status = SignUpStatus.Uninitialized;
  bool _isButtonDisabled = true;

  bool get isButtonDisabled => _isButtonDisabled;
  SignUpStatus get signUpStatus => _status;

  void setStatus(SignUpStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void toggleButton(bool isButtonDisabled) {
    _isButtonDisabled = isButtonDisabled;
    notifyListeners();
  }

  void validateInput({String value, TextEditingController textController}) {
    if (value.isNotEmpty && textController.text.isNotEmpty) {
      if (_isButtonDisabled) {
        print('[SignUpPageViewModel] Enabling Button');
        _isButtonDisabled = false;
        notifyListeners();
      }
    } else if (!_isButtonDisabled) {
      print('[SignUPPageViewModel] Disabling Button');
      _isButtonDisabled = true;
      notifyListeners();
    }
  }
}
