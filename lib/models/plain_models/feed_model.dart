import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/repository/post.dart';
import 'package:instagram/repository/profile.dart';
import 'package:scoped_model/scoped_model.dart';

enum FeedStatus {
  // Fetching posts
  busy,
  // Has no posts
  nothing,
  // Has posts
  fruitful,
  // wait for refresh
  idle
}

class FeedModel extends Model {
  List<Post> posts = [];
  FeedStatus _status = FeedStatus.idle;

  FeedStatus get status => _status;

  DatabaseReference dr = FirebaseDatabase.instance.reference().child('posts');

  Future<void> fetch(List<Profile> followers) async {
    _status = FeedStatus.busy;
    notifyListeners();
    print('[FeedModel] Started fetching posts');
    Map<String, Post> postMap = {};
    for (Profile follower in followers) {
      DataSnapshot ds = await dr.child(follower.uid).once();
      if (ds.value != null) {
        print('Post retrieved: ${ds.value}');
        for (String postKey in ds.value.keys) {
          var post = Post.fromJson(ds.value[postKey], postKey);
          postMap[postKey] = post;
        }
      }
    }
    List<String> sortedKeys = postMap.keys.toList()..sort();
    this.posts = [];
    while (sortedKeys.isNotEmpty) {
      String lateKey = sortedKeys.removeLast();
      this.posts.add(postMap[lateKey]);
    }
    if (this.posts.isEmpty) {
      _status = FeedStatus.nothing;
    } else {
      _status = FeedStatus.fruitful;
    }
    notifyListeners();
    print('[FeedModel] posts fetched! Posts found: ${this.posts.length}');
  }
}
