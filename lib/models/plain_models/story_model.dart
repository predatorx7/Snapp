import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/models/plain_models/post.dart';
import 'package:instagram/models/plain_models/story.dart';
import 'package:scoped_model/scoped_model.dart';

enum StoryStatus {
  // Fetching posts
  busy,
  // Has no posts
  nothing,
  // Has posts
  fruitful,
  // wait for refresh
  idle
}

class StoryModel extends Model {
  List<Story> stories = [];
  StoryStatus _status = StoryStatus.idle;

  StoryStatus get status => _status;

  DatabaseReference dr = FirebaseDatabase.instance.reference().child('posts');
  Future<void> fetch(List<dynamic> followers) async {
    _status = StoryStatus.busy;
    notifyListeners();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    print('[FeedModel] Started fetching posts');
    Map<String, Story> storyMap = {};
    for (String follower in followers) {
      DataSnapshot ds = await dr.child(follower).once();
      if (ds.value != null) {
        for (String postKey in ds.value.keys) {
          var story = Story.createFromMap(ds.value[postKey], postKey);
          if (story.expiryTime > currentTime) {
            storyMap[postKey] = story;
          }
        }
      }
    }
    List<String> sortedKeys = storyMap.keys.toList()..sort();
    this.stories = [];
    while (sortedKeys.isNotEmpty) {
      String lateKey = sortedKeys.removeLast();
      this.stories.add(storyMap[lateKey]);
    }
    if (this.stories.isEmpty) {
      _status = StoryStatus.nothing;
    } else {
      _status = StoryStatus.fruitful;
    }
    notifyListeners();
    print('[FeedModel] posts fetched! Posts found: ${this.stories.length}');
  }
}
