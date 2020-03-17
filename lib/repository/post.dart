import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Post {
  /// Timestamp of post creation (UNIX Epoch Milliseconds) optional
  int creationTime;

  // Post description or Caption
  String description;

  /// Will have post image URL `required`
  String imageURL;

  /// UserId of publisher `required`
  String publisher;

  String publisherUsername;

  List likes;

  /// This is key for database values of Posts
  String postKey;

  Post({
    this.creationTime,
    this.description,
    @required this.imageURL,
    @required this.publisher,
    @required this.publisherUsername,
    this.postKey,
    this.likes,
  });

  @deprecated
  static List _getFromArray(data) {
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

  factory Post.fromDataSnapshot(DataSnapshot snapshot) {
    final jsonResponse = json.decode(snapshot.value);
    var postKey = jsonResponse.keys.toList()[0];
    return Post.fromJson(jsonResponse, postKey);
  }

  factory Post.fromJson(Map parsedJson, String key) {
    return Post(
      postKey: key ?? '',
      creationTime: parsedJson['creationTime'] as int,
      description: parsedJson['description'] as String ?? '',
      imageURL: parsedJson['imageURL'] as String,
      publisher: parsedJson['publisher'] as String,
      publisherUsername: parsedJson['publisherUsername'] as String,
      // likes: _getFromArray(parsedJson['likes'] ?? []),
      likes: (parsedJson['likes'] as Map).values.toList(),
    );
  }

  /// Provides data in JSON format. Provides current time if not optionally disabled.
  Map<String, dynamic> toJson({bool provideWithCurrentTime = false}) {
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
      "publisherUsername": publisherUsername,
    };
  }
}
