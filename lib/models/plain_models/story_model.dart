import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/repository/post.dart';
import 'package:instagram/repository/profile.dart';
import 'package:instagram/repository/story.dart';
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

  /// Collection of stories for a user
  Map<String, List<Story>> collection = {};
  StoryStatus get status => _status;

  DatabaseReference dr = FirebaseDatabase.instance.reference().child('stories');
  Future<void> fetch(List<Profile> followers) async {
    _status = StoryStatus.busy;
    notifyListeners();
    print('[StoryModel] Started fetching stories');
    DateTime _time = DateTime.now();
    int startFromTime =
        new DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch;
    Map<String, Story> storyMap = {};
    Map<String, List<Story>> _collection = {};
    for (Profile follower in followers) {
      DataSnapshot ds =
          await dr.child(follower.uid).orderByChild('creationTime').once();
      if (ds.value != null) {
        List storyKeys = ds.value.keys;
        storyKeys.sort();
        for (String storyKey in storyKeys) {
          var story = Story.createFromMap(ds.value[storyKey], storyKey);
          storyMap[storyKey] = story;
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
      } else {
        print('No Stories retrieved for $follower');
      }
    }
    this.collection = {};
    this.collection.addAll(_collection);
//    List<String> sortedKeys = storyMap.keys.toList()..sort();
//    this.stories = [];
//    while (sortedKeys.isNotEmpty) {
//      String lateKey = sortedKeys.removeLast();
//      this.stories.add(storyMap[lateKey]);
//    }
    if (this.collection.keys.toList().isEmpty) {
      _status = StoryStatus.nothing;
      print('No stories found');
    } else {
      print(
          '[StoryModel] stories fetched! These users uploaded Stories: ${this.collection.length}');
      _status = StoryStatus.fruitful;
    }
    notifyListeners();
  }
}
