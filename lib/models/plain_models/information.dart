import 'package:flutter/material.dart';
import 'package:instagram/core/utils/Adapt_widget.dart';
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
}
