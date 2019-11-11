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

  /// Collection of stories for a user
  Map<String, List<Story>> collection = {};
  StoryStatus get status => _status;

  DatabaseReference dr = FirebaseDatabase.instance.reference().child('stories');
  Future<void> fetch(List<dynamic> followers) async {
    _status = StoryStatus.busy;
    notifyListeners();
    print('[StoryModel] Started fetching stories');
    DateTime _time = DateTime.now();
    int startFromTime =
        new DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch;
    Map<String, Story> storyMap = {};
    Map<String, List<Story>> _collection = {};
    for (String follower in followers) {
      DataSnapshot ds = await dr
          .child(follower)
          .orderByChild('creationTime')
          .once();
      if (ds.value != null) {
        for (String storyKey in ds.value.keys) {
          print('Value: ${ds.value.values.toString()}');
          var story = Story.createFromMap(ds.value[storyKey], storyKey);
          storyMap[storyKey] = story;
          print('Difference ${DateTime.fromMillisecondsSinceEpoch(startFromTime).difference(_time).inSeconds} > ${Duration(days: 1).inSeconds} ?');
          if (_time.difference(DateTime.fromMillisecondsSinceEpoch(startFromTime)).inSeconds < Duration(days: 1).inSeconds) {
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
      print('[StoryModel] stories fetched! These users uploaded Stories: ${this.collection.length}');
      _status = StoryStatus.fruitful;
    }
    notifyListeners();
  }
}
