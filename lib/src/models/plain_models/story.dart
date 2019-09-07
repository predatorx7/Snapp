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

  Story({
    this.creationTime,
    this.expiryTime,
    @required this.imageURL,
    @required this.publisher,
    this.storyKey,
  });

  Story.fromMap(DataSnapshot snapshot, String publisher)
      : storyKey = snapshot.key,
        creationTime = snapshot.value['creationTime'] ?? '',
        expiryTime = snapshot.value['expiryTime'] ?? '',
        imageURL = snapshot.value['imageURL'] ?? '',
        publisher = publisher ?? '';

  /// Provides data in JSON format. Provides current time if not optionally disabled.
  Map<String, dynamic> toJson({bool provideWithCurrentTime = true}) {
    /// Gets Current time
    if (provideWithCurrentTime == true) {
      DateTime currentTime = new DateTime.now();
      creationTime = currentTime.millisecondsSinceEpoch;
      expiryTime = currentTime.add(Duration(days: 1)).millisecondsSinceEpoch;
    }

    return {
      "creationTime": creationTime,
      "expiryTime": expiryTime,
      "imageURL": imageURL,
      "publisher": publisher,
    };
  }
}