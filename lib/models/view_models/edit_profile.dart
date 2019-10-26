import 'package:flutter/foundation.dart';
import 'package:instagram/models/plain_models/profile.dart';

class EditProfileModel extends ChangeNotifier {
  Profile _information;
  bool isBusy = false;
  bool _usernameAvailable = true;
  bool usernameChanged = false;
  bool get usernameAvailable => _usernameAvailable;

  setUsernameAvailable(bool usernameAvailable) {
    _usernameAvailable = usernameAvailable;
    notifyListeners();
  }

  setUsernameFieldChange() {
    usernameChanged = true;
    notifyListeners();
  }

  Profile get information => _information;
  set information(Profile value) => value;

  setInformation(Profile information) {
    _information = information;
    notifyListeners();
  }

  toggleBusy(bool value) {
    isBusy = value;
    notifyListeners();
  }
}
