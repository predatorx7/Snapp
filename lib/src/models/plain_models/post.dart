import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class Post {
  /// Timestamp of post creation (UNIX Epoch Milliseconds) optional
  int creationTime;

  // Post description or Caption
  String description;

  /// Will have post image URL `required`
  String imageURL;

  /// UserId of publisher `required`
  String publisher;

  /// This is key for database values of Posts
  String postKey;

  Post({
    this.creationTime,
    this.description,
    @required this.imageURL,
    @required this.publisher,
    this.postKey,
  });

  Post.fromMap(DataSnapshot snapshot, String publisher)
      : postKey = snapshot.key,
        creationTime = snapshot.value['creationTime'] ?? '',
        description = snapshot.value['description'] ?? '',
        imageURL = snapshot.value['imageURL'] ?? '',
        publisher = publisher ?? '';

  /// Provides data in JSON format. Provides current time if not optionally disabled.
  Map<String, dynamic> toJson({bool provideWithCurrentTime = true}) {
    /// Gets Current time
    if (provideWithCurrentTime == true) {
      DateTime currentTime = new DateTime.now();
      creationTime = currentTime.millisecondsSinceEpoch;
    }

    return {
      "creationTime": creationTime,
      "description": description,
      "imageURL": imageURL,
      "publisher": publisher,
    };
  }
}