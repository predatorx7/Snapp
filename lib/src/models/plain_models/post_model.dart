class Post {
  String postedByUser;
  String postCaption;
  String postId;
  String media;
  List<String> likedBy;
  /// Use Animated Firebase list to show comment list
  Map<String, String> comments;

  Post({this.postedByUser, this.postCaption, this.postId, this.media});

  Post.fromMap(Map snapshot, String postedByUser)
      : postedByUser = postedByUser ?? '',
        postCaption = snapshot['postCaption'] ?? '',
        postId = snapshot['postId'] ?? '',
        media = snapshot['media'] ?? '';

  toJson() {
    return {
      "postCaption": postCaption,
      "postId": postId,
      "media": media,
    };
  }
}
