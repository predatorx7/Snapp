import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/models/plain_models/post.dart';
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
  Future<void> fetch(List<dynamic> followers) async {
    _status = FeedStatus.busy;
    notifyListeners();
    print('[FeedModel] Started fetching posts');
    Map<String, Post> postMap = {};
    for (String follower in followers) {
      DataSnapshot ds = await dr.child(follower).once();
      if (ds.value != null) {
        for (String postKey in ds.value.keys) {
          var post = Post.createFromMap(ds.value[postKey], postKey);
          postMap[postKey] = post;
        }
      }
    }
    List<String> sortedKeys = postMap.keys.toList()..sort();
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
