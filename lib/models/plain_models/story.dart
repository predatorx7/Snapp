import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class Story {
  /// Timestamp of story creation (UNIX Epoch Milliseconds) optional
  int creationTime;

  /// Timestamp of story expiration (UNIX Epoch Milliseconds) optional
  int expiryTime;

  /// Will have story image URL `required`
  String imageURL;

  /// UserId of publisher `required`
  String publisher;

  /// This is key for database values of Story
  String storyKey;

  String publisherUsername;

  List<String> views;

  Story({
    this.creationTime,
    this.expiryTime,
    @required this.imageURL,
    @required this.publisher,
    this.storyKey,
    this.publisherUsername,
  }) {
    DateTime currentTime = new DateTime.now();
    if (creationTime == null) {
      creationTime = currentTime.millisecondsSinceEpoch;
    }
    if (expiryTime == null) {
      expiryTime = currentTime.add(Duration(days: 1)).millisecondsSinceEpoch;
    }
  }

  Story.fromMap(DataSnapshot snapshot, String publisher)
      : storyKey = snapshot.key,
        creationTime = snapshot?.value['creationTime'],
        expiryTime = snapshot?.value['expiryTime'],
        imageURL = snapshot.value['imageURL'] ?? '',
        publisherUsername = snapshot.value['publisherUsername'] ?? '',
        publisher = publisher ?? '';

  /// Provides data in JSON format. Provides current time if not optionally disabled.
  Map<String, dynamic> toJson() {
    return {
      "creationTime": creationTime,
      "expiryTime": expiryTime,
      "imageURL": imageURL,
      "publisher": publisher,
      "publisherUsername": publisherUsername,
    };
  }

  List _getFromArray(data) {
    // When creating a child by pushing, only the last post pushed has a unique key, the previous ones are altered with incremented numbers on push. Thus
    // on removing the last child, list is parsed instead of a Map. The below workaround try/catch deals with it.
    List listIs;
    try {
      Map rawPostsMap = data ?? {};
      listIs = rawPostsMap.values.toList() ?? [];
    } catch (e) {
      List rawPostsList = data ?? [];
      listIs = rawPostsList ?? [];
    }
    return listIs;
  }

  Story.createFromMap(Map dataMap, String key) {
    storyKey = key;
//    views = _getFromArray(dataMap['views'] ?? []);
    creationTime = dataMap['creationTime'] ?? null;
    imageURL = dataMap['imageURL'] ?? '';
    publisher = dataMap['publisher'] ?? '';
    publisherUsername = dataMap['publisherUsername'] ?? '';
    expiryTime = dataMap['expiryTime'] ?? null;
  }
}
