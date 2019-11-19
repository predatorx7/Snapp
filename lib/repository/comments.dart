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

  String pulisherUsername;

  Comment({
    this.comment,
    this.commentKey,
    this.creationTime,
    this.postKey,
    this.publisher,
    this.pulisherUsername,
  });

  Comment.fromMap(Map data, commentKey)
      : commentKey = commentKey,
        comment = data['comment'] ?? '',
        creationTime = data['creationTime'] ?? '',
        postKey = data['postKey'],
        publisher = data['publisher'] ?? '',
        pulisherUsername = data['pulisherUsername'] ?? '';

  /// Provides data in JSON format. Provides current time if not optionally disabled.
  Map<String, dynamic> toJson({bool provideWithCurrentTime = true, String commentKey}) {
    /// Gets Current time
    if (provideWithCurrentTime == true) {
      DateTime currentTime = new DateTime.now();
      creationTime = currentTime.millisecondsSinceEpoch;
    }

    return {
      "commentKey": commentKey,
      "comment": comment,
      "creationTime": creationTime,
      "postKey": postKey,
      "publisher": publisher,
      "pulisherUsername": pulisherUsername,
    };
  }
}
