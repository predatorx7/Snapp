import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/utils/Adapt_widget.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'profile.dart';

class InfoModel with ChangeNotifier {
  Profile _info = Profile();
  double _heightOfFlexSpace;

  double get heightOfFlexSpace => _heightOfFlexSpace;

  Adapt _flexibleSpaceHeight = Adapt(size: 260);
  InfoModel();
  Profile get info => _info;
  void setInfo(Profile information) {
    _info = information;
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _info.bio);
    notifyListeners();
  }

  void shout() {
    notifyListeners();
  }

  void setInfoSilently(Profile information) {
    _info = information;
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _info.bio);
  }
}
