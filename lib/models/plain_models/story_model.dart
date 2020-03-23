import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
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

class Holder {
  var follower, startFromTime, storyMap, _collection, dr, _time;
  Holder(follower, startFromTime, storyMap, _collection, dr, _time);
}

class StoryModel extends Model {
  // List<Story> stories = [];
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
    Holder args = Holder(null, startFromTime, storyMap, _collection, dr, _time);
    for (Profile follower in followers) {
      args.follower = follower;
      compute(fetchStoriesFor, args);
      // DataSnapshot ds =
      //     await dr.child(follower.uid).orderByChild('creationTime').once();
      // if (ds.value != null) {
      //   List storyKeys = ds.value.keys;
      //   storyKeys.sort();
      //   for (String storyKey in storyKeys) {
      //     var story = Story.createFromMap(ds.value[storyKey], storyKey);
      //     storyMap[storyKey] = story;
      //     if (_time
      //             .difference(
      //                 DateTime.fromMillisecondsSinceEpoch(startFromTime))
      //             .inSeconds <
      //         Duration(days: 1).inSeconds) {
      //       print('$storyKey is a valid story');
      //       _collection.putIfAbsent(
      //         story.publisher,
      //         () => [],
      //       );
      //       _collection[story.publisher].add(story);
      //     }
      //   }
      // } else {
      //   print('No Stories retrieved for $follower');
      // }
    }
    this.collection = {};
    this.collection.addAll(args._collection);
//    List<String> sortedKeys = storyMap.keys.toList()..sort();
//    this.stories = [];
//    while (sortedKeys.isNotEmpty) {
//      String lateKey = sortedKeys.removeLast();
//      this.stories.add(storyMap[lateKey]);
//    }
    print(collection);
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

fetchStoriesFor(Holder args) async {
  // start
  DataSnapshot ds = await args.dr
      .child(args.follower.uid)
      .orderByChild('creationTime')
      .once();
  if (ds.value != null) {
    List storyKeys = ds.value.keys;
    storyKeys.sort();
    for (String storyKey in storyKeys) {
      var story = Story.createFromMap(ds.value[storyKey], storyKey);
      args.storyMap[storyKey] = story;
      if (args._time
              .difference(
                  DateTime.fromMillisecondsSinceEpoch(args.startFromTime))
              .inSeconds <
          Duration(days: 1).inSeconds) {
        print('$storyKey is a valid story');
        args._collection.putIfAbsent(
          story.publisher,
          () => [],
        );
        args._collection[story.publisher].add(story);
      }
    }
  } else {
    print('No Stories retrieved for ${args.follower}');
  }
}
