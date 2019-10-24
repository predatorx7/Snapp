import 'package:flutter/foundation.dart';
import 'package:instagram/models/plain_models/profile.dart';

class EditProfileModel extends ChangeNotifier {
  Profile _information;
  bool isBusy = false;
  bool _usernameAvailable = false;

  bool get usernameAvailable => _usernameAvailable;

  setUsernameAvailable(bool usernameAvailable) {
    _usernameAvailable = usernameAvailable;
    notifyListeners();
  }

  Profile get information => _information;
  setInformation(Profile information) {
    _information = information;

    notifyListeners();
  }

  toggleBusy(bool value) {
    isBusy = !value;
    notifyListeners();
  }
}
