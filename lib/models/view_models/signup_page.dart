import 'package:flutter/cupertino.dart';
import 'package:instagram/core/services/profile.dart';

enum SignUpStatus { Uninitialized, Started, Running, Checking, Failed, Success }

class SignUpViewModel with ChangeNotifier {
  SignUpStatus _status = SignUpStatus.Uninitialized;
  bool _isButtonDisabled = true, _isTapped = false, _showError = false;
  String _username;

  String get username => _username;

  bool get isButtonDisabled => _isButtonDisabled;
  bool get isTapped => _isTapped;
  bool get showError => _showError;
  SignUpStatus get signUpStatus => _status;
  String _oldUsername;
  bool hasUsername = false;
  bool _isDone = false;

  bool get isDone => _isDone;

  setDone(bool isDone) {
    _isDone = isDone;
    notifyListeners();
  }

  String get oldUsername => _oldUsername;
  set oldUsername(String x) => _oldUsername = x;
  setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setStatus(SignUpStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void toggleButton(bool isButtonDisabled) {
    _isButtonDisabled = isButtonDisabled;
    notifyListeners();
  }

  void setTap(bool isTapped) {
    _isTapped = isTapped;
    notifyListeners();
  }

  void setError(bool showError) {
    _showError = showError;
    notifyListeners();
  }

  void setButton(bool isDisabled) {
    _isButtonDisabled = isDisabled;
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

  Future<bool> provideUsername(String email, String fullName) async {
    String username = await ProfileService().autoUsername(email, fullName);
    oldUsername = _username;
    _username = username;
    hasUsername = true;
    notifyListeners();
    return true;
  }
}