import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class Comment {
  /// Comment `required`
  String comment;

  /// This is key for database values of Posts `required`
  String commentKey;

  /// Timestamp of post creation (UNIX Epoch Milliseconds) optional
  int creationTime;

  /// Post Key of Post on which this comment exists
  String postKey;

  /// UserId of publisher `required`
  String publisher;

  Comment({
    @required this.comment,
    this.commentKey,
    this.creationTime,
    @required this.postKey,
    @required this.publisher,
  });

  Comment.fromMap(DataSnapshot snapshot, String publisher)
      : commentKey = snapshot.key,
        comment = snapshot.value['comment'] ?? '',
        creationTime = snapshot.value['creationTime'] ?? '',
        postKey = snapshot.value['postKey'],
        publisher = publisher ?? '';

  /// Provides data in JSON format. Provides current time if not optionally disabled.
  Map<String, dynamic> toJson({bool provideWithCurrentTime = true}) {
    /// Gets Current time
    if (provideWithCurrentTime == true) {
      DateTime currentTime = new DateTime.now();
      creationTime = currentTime.millisecondsSinceEpoch;
    }

    return {
      "comment": comment,
      "creationTime": creationTime,
      "postKey": postKey,
      "publisher": publisher,
    };
  }
}
