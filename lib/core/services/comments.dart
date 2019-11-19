import 'package:firebase_database/firebase_database.dart';
import '../../repository/comments.dart';

/// Provides CRUD operations with comment info in database
class CommentService {
  /// Creates a new user comment in database
  static createComment(String _postKey, String _commentIs, String commentPublisher, String publisherUsername) {
    Comment _comment = new Comment(
      postKey: _postKey,
      comment: _commentIs,
      publisher: commentPublisher,
      pulisherUsername: publisherUsername,
    );
    try {
      print('[Comment Service] Commenting');
      FirebaseDatabase.instance
          .reference()
          .child("comments/$_postKey")
          .push()
          .set(_comment.toJson());
      print('[Comment Service] Done');
    } catch (e) {
      print('An unexpected error occured.\nError: $e');
    }
  }

  /// To retrieve user's whole comment from database
  static Future<List<Comment>> fetchComment(String postKey) async {
    List<Comment> commentList = [];
    print('[Comment Service] Fetching comments');
    await FirebaseDatabase.instance
        .reference()
        .child("comments/$postKey")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        print('[Comment Service] ${snapshot.value}');
        for (String commentKey in snapshot.value.keys.toList()) {
          Map comment = snapshot.value[commentKey];
          Comment com = Comment.fromMap(comment, commentKey);
          commentList.add(com);
        }
      } else {
        print('[Comment Service] No comments found');
        return null;
      }
    });
    print('[Comment Service] Comments found! ${commentList.length}');
    return commentList;
  }

  /// Delete user comment
  static Future<void> deleteComment(Comment comment)async {
    print('[Comment Service] Deleting comment');
    await FirebaseDatabase.instance
        .reference()
        .child("comments/${comment.postKey}/${comment.commentKey}")
        .remove()
        .then((_) {
      print('Comment deleted');
    });
  }
}
