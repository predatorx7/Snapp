import 'package:flutter/cupertino.dart';

class LoginPageViewModel with ChangeNotifier {
  bool _isButtonDisabled = true;

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
