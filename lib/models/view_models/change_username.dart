import 'package:flutter/cupertino.dart';

enum ChangeUsernameStatus { Standby, Working, Failed }

class ChangeUsernameViewModel with ChangeNotifier {
  bool _isButtonDisabled = true;
  bool _valid = true;
  ChangeUsernameStatus _status = ChangeUsernameStatus.Standby;

  ChangeUsernameStatus get status => _status;

  setStatus(ChangeUsernameStatus status) {
    _status = status;
    notifyListeners();
  }

  String _errorText;

  String get errorText => _errorText;

  setErrorText(String errorText) {
    _errorText = errorText;
    notifyListeners();
  }

  bool get valid => _valid;

  setValidity(bool valid) {
    _valid = valid;
    notifyListeners();
  }

  String _username;

  String get username => _username;

  setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  bool get isButtonDisabled => _isButtonDisabled;

  void toggleButton(bool isButtonDisabled) {
    _isButtonDisabled = isButtonDisabled;
    notifyListeners();
  }

  void validateInput({String value, TextEditingController textController}) {
    if (value.isNotEmpty && textController.text.isNotEmpty) {
      if (_isButtonDisabled) {
        print('[LoginPageViewModel] Enabling Button');
        _isButtonDisabled = false;
        notifyListeners();
      }
    } else if (!_isButtonDisabled) {
      print('[LoginPageViewModel] Disabling Button');
      _isButtonDisabled = true;
      notifyListeners();
    }
  }
}
