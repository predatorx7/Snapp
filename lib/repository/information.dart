import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/utils/Adapt_widget.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'package:instagram/models/plain_models/story.dart';
import '../models/plain_models/profile.dart';

class InfoRepo with ChangeNotifier {
  double _heightOfFlexSpace;
  // UID of user
  String userUID = "";
  Profile _profile = Profile();
  List<Story> activeStory = [];
  List<Story> storyArchive = [];
  List<Post> posts = [];
  DatabaseReference _dr = FirebaseDatabase.instance.reference();
  Profile get profile => _profile;
  double get heightOfFlexSpace => _heightOfFlexSpace;

  Adapt _flexibleSpaceHeight = Adapt(size: 260);
  Profile get info => _profile;
  InfoRepo(this.userUID) {
    refreshAll();
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _profile.bio);
  }
  InfoRepo.setInfo(Profile information) {
    this._profile = information;
    this.userUID = this._profile.uid;
    refreshPosts();
    refreshStory();
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _profile.bio);
    notifyListeners();
  }

  void updateInfo(Profile information) {
    this._profile = information;
    this.userUID = this._profile.uid;
    refreshPosts();
    refreshStory();
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _profile.bio);
    notifyListeners();
  }

  void notifyChanges() {
    notifyListeners();
  }

  void setInfoSilently(Profile information) {
    this._profile = information;
    this.userUID = this._profile.uid;
    refreshPosts();
    refreshStory();
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _profile.bio);
  }

  Future<void> refreshProfile() async {
    try {
      DataSnapshot snapshot =
          await _dr.child('profiles/${this.userUID}').once();
      if (snapshot.value != null) {
        this._profile = Profile.fromMap(snapshot);
      }
      notifyListeners();
    } on Exception catch (e) {
      print('An Exception happened while refreshing profile information: $e');
    }
  }

  Future<void> refreshStory() async {
    try {
      DataSnapshot snapshot = await _dr.child('stories/${this.userUID}').once();
      if (snapshot.value != null) {
        List<Story> _stories = [];
        for (var i in snapshot.value.keys.toList()) {
          _stories.add(Story.createFromMap(snapshot.value, i));
        }
        this.storyArchive = _stories;
      }
      notifyListeners();
    } on Exception catch (e) {
      print('An Exception happened while refreshing profile information: $e');
    }
  }

  Future<void> refreshPosts() async {
    try {
      DataSnapshot snapshot = await _dr.child('posts/${this.userUID}').once();
      if (snapshot.value != null) {
        List<Post> _posts = [];
        print(snapshot.value);
        for (var i in snapshot.value.keys.toList()) {
          _posts.add(Post.createFromMap(snapshot.value[i], i));
        }
        this.posts = _posts;
      }
      notifyListeners();
    } on Exception catch (e) {
      print('An Exception happened while refreshing profile information: $e');
    }
  }

  Future<void> refreshAll() async {
    refreshProfile();
    refreshPosts();
    refreshStory();
  }
}
