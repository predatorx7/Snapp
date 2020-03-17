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
    @required this.imageURL,
    @required this.publisher,
    this.storyKey,
    this.publisherUsername,
  }) {
    this.expiryTime = Duration(days: 1).inMilliseconds + this.creationTime;
  }

  Story.fromMap(DataSnapshot snapshot, String publisher)
      : storyKey = snapshot.key,
        creationTime = snapshot.value['creationTime'] ?? '',
        expiryTime = snapshot.value['expiryTime'] ?? '',
        imageURL = snapshot.value['imageURL'] ?? '',
        publisherUsername = snapshot.value['publisherUsername'] ?? '',
        publisher = publisher ?? '';

  /// Provides data in JSON format. Provides current time if not optionally disabled.
  Map<String, dynamic> toJson() {
    assert(creationTime != null,
        "Creation time for a story should not be null: $creationTime");
    return {
      "creationTime": creationTime,
      "expiryTime":
          expiryTime ?? Duration(days: 1).inMilliseconds + creationTime,
      "imageURL": imageURL,
      "publisher": publisher,
      "publisherUsername": publisherUsername,
    };
  }

  Story.createFromMap(Map dataMap, String key) {
    storyKey = key;
//    views = _getFromArray(dataMap['views'] ?? []);
    creationTime = dataMap['creationTime'] ?? null;
    imageURL = dataMap['imageURL'] ?? '';
    publisher = dataMap['publisher'] ?? '';
    publisherUsername = dataMap['publisherUsername'] ?? '';
  }
}
