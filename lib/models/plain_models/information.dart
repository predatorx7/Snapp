import 'package:flutter/material.dart';
import 'profile.dart';

class InfoModel with ChangeNotifier {
  Profile _info = Profile();
  InfoModel();
  Profile get info => _info;

  set info(Profile information) => _info;

  void setInfo(Profile infoDetails) {
    _info = infoDetails;
    notifyListeners();
  }
}
