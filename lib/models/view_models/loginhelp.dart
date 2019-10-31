import 'package:scoped_model/scoped_model.dart';

enum Status { Uninitialized, Started, Running, Checking, Failed, Success }

class LoginHelpModel extends Model {
  Status _status = Status.Uninitialized;
  bool _isButtonDisabled = true, _isTapped = false, _showError = false;
  String _username;

  String get username => _username;

  bool get isButtonDisabled => _isButtonDisabled;
  bool get isTapped => _isTapped;
  bool get showError => _showError;
  Status get signUpStatus => _status;

  setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setStatus(Status newStatus) {
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
}
