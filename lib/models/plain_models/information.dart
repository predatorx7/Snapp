import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/utils/Adapt_widget.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'profile.dart';

class InfoModel with ChangeNotifier {
  Profile _info = Profile();
  double _heightOfFlexSpace;
  List<dynamic> _posts = [];

  Future<List<dynamic>> get posts async {
    if (_info.uid?.isNotEmpty ?? null || _posts == []) {
      DataSnapshot res = await FirebaseDatabase.instance
          .reference()
          .child("posts/${_info.uid}")
          .once();
      this._posts = res.value.keys.toList();
      notifyListeners();
      return _posts;
    } else {
      print('Called on null users');
      return _posts;
    }
  }

  double get heightOfFlexSpace => _heightOfFlexSpace;

  Adapt _flexibleSpaceHeight = Adapt(size: 260);
  InfoModel();
  Profile get info => _info;
  Future<void> setInfo(Profile information) async {
    _info = information;
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _info.bio);
    notifyListeners();
  }

  void shout() {
    notifyListeners();
  }

  Future<void> setInfoSilently(Profile information) async {
    _info = information;
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _info.bio);
  }
}
