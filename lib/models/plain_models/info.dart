import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/core/utils/Adapt_widget.dart';
import 'package:instagram/repository/post.dart';
import 'package:instagram/repository/story.dart';
import '../../repository/profile.dart';

/// InfoModel provides APIs to handle app-wide & online data related to user.
/// Should be used to handle data of user of this device's repository.
class InfoModel with ChangeNotifier {
  double _heightOfFlexSpace;
  // UID of user
  String userUID = "";
  Profile _profile = Profile();
  List<Story> activeStory = [];
  List<Story> storyArchive = [];
  List<Profile> followers = [];
  List<Profile> following = [];
  List<Post> posts = [];
  DatabaseReference _dr = FirebaseDatabase.instance.reference();
  Profile get profile => _profile;
  double get heightOfFlexSpace => _heightOfFlexSpace;

  Adapt _flexibleSpaceHeight = Adapt(size: 270);
  Profile get info => _profile;
  InfoModel(this.userUID) {
    refreshAll();
    _heightOfFlexSpace = _flexibleSpaceHeight.withText(text: _profile.bio);
  }
  InfoModel.setInfo(Profile information) {
    this._profile = information;
    this.userUID = this._profile.uid;
    refreshPosts();
    refreshStory();
    refreshFollow();
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
        this._profile = Profile.fromDataSnapshot(snapshot);
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

    try {
      /// Collection of stories for a user
      Map<String, List<Story>> collection = {};

      /// Extracting active stories
      DateTime _time = DateTime.now();
      int startFromTime =
          new DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch;
      Map<String, Story> storyMap = {};
      Map<String, List<Story>> _collection = {};
      DataSnapshot ds = await FirebaseDatabase.instance
          .reference()
          .child('stories')
          .child(this.userUID)
          .orderByChild('creationTime')
          .once();
      if (ds.value != null) {
        for (String storyKey in ds.value.keys) {
          print('Value: ${ds.value.values.toString()}');
          var story = Story.createFromMap(ds.value[storyKey], storyKey);
          storyMap[storyKey] = story;
          print(
              'Difference ${DateTime.fromMillisecondsSinceEpoch(startFromTime).difference(_time).inSeconds} > ${Duration(days: 1).inSeconds} ?');
          if (_time
                  .difference(
                      DateTime.fromMillisecondsSinceEpoch(startFromTime))
                  .inSeconds <
              Duration(days: 1).inSeconds) {
            print('$storyKey is a valid story');
            _collection.putIfAbsent(
              story.publisher,
              () => [],
            );
            _collection[story.publisher].add(story);
          }
        }
      } else {}
      collection = {};
      collection.addAll(_collection);
//    }
      if (collection.keys.toList().isEmpty) {
        print('No stories found');
      } else {
        this.activeStory = collection[this.userUID].toList();
        print(
            'stories fetched! These users uploaded Stories: $collection.length}');
      }
    } on Exception catch (e) {
      print('An Exception happened while refreshing profile information: $e');
    }
    notifyChanges();
  }

  Future<void> refreshPosts() async {
    try {
      DataSnapshot snapshot = await _dr.child('posts/${this.userUID}').once();
      if (snapshot.value != null) {
        List<Post> _posts = [];
        print(snapshot.value);
        for (var i in snapshot.value.keys.toList()) {
          _posts.add(Post.fromJson(snapshot.value[i], i));
        }
        this.posts = _posts;
      }
    } on Exception catch (e) {
      print('An Exception happened while refreshing profile information: $e');
    }
  }

  /// Refresh followers & followings list
  Future<void> refreshFollow() async {
    try {
      // Fetching list of followers for this user
      DataSnapshot snapshot =
          await _dr.child('followers_of/${this.userUID}').once();
      if (snapshot.value != null) {
        List<Profile> _followers = [];
        for (var followerID in snapshot.value.keys.toList()) {
          // Getting Profile snapshot of this follower using his followerID
          var snap = await ProfileService()
              .getProfileSnapshot(snapshot.value[followerID]);
          String key = snap.value.keys.first;
          // Adding this follower's Profile in followers list
          _followers.add(Profile.fromMap(
            snap.value[key],
          ));
        }
        this.followers = _followers;
      }
      notifyListeners();
    } on Exception catch (e) {
      print('An Exception happened while refreshing profile information: $e');
    }
    try {
      // Fetching list of follows for this user
      DataSnapshot snapshot =
          await _dr.child('followings_of/${this.userUID}').once();
      if (snapshot.value != null) {
        List<Profile> _following = [];
        for (var followID in snapshot.value.keys.toList()) {
          // Getting Profile snapshot of this followed user using his followID
          DataSnapshot snap = await ProfileService()
              .getProfileSnapshot(snapshot.value[followID]);
          String key = snap.value.keys.first;
          // Adding this followed user's Profile in following list
          _following.add(Profile.fromMap(snap.value[key]));
        }
        this.following = _following;
      }
      notifyListeners();
    } on Exception catch (e) {
      print('An Exception happened while refreshing profile information: $e');
    }
  }

  Future<void> refreshAll() async {
    this.refreshProfile();
    this.refreshPosts();
    this.refreshStory();
    this.refreshFollow();
  }

  Profile getFollower(String uid) {
    for (Profile thisFollower in this.following) {
      if (thisFollower.uid == uid) {
        return thisFollower;
      }
    }
    return null;
  }

  bool removePost(Post postToRemove) {
    var index = 0;
    for (Post aPost in this.posts) {
      if (aPost.publisher == postToRemove.publisher &&
          aPost.creationTime == postToRemove.creationTime) {
        this.posts.removeAt(index);
        notifyListeners();
        return true;
      }
      index++;
    }
    return false;
  }
}
