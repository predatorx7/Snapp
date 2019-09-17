import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram/src/models/plain_models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoModel with ChangeNotifier {
  Profile _info = Profile();
  InfoModel();
  Profile get info => _info;

  set info(Profile information) => _info;

  Future modifyInfo(Profile infoDetails) async {
    await _setInfo(infoDetails.toJson());
    _info = infoDetails;
    notifyListeners();
  }

  InfoModel.updatefromStore(SharedPreferences sharedPreferences) {
    Map<String, dynamic> infoMap;
    String stringMap = (sharedPreferences.getString('info') ?? null);
    infoMap = json.decode(stringMap);
    _info = Profile(
        uid: infoMap['uid'] ?? '',
        bio: infoMap['bio'] ?? '',
        email: infoMap['email'] ?? '',
        followers: infoMap['followers'] ?? [],
        follows: infoMap['follows'] ?? [],
        fullName: infoMap['fullName'] ?? '',
        gender: infoMap['gender'] ?? '',
        posts: infoMap['posts'] ?? [],
        profileImage: infoMap['profileImage'] ?? '',
        stories: infoMap['stories'] ?? [],
        username: infoMap['username'] ?? '');
    notifyListeners();
  }

  Future _setInfo(Map<String, dynamic> infoMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringMap = json.encode(infoMap);
    await prefs.setString('info', stringMap);
  }
}
