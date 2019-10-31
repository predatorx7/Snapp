import 'package:firebase_database/firebase_database.dart';
import '../../models/plain_models/comments.dart';

/// Provides CRUD operations with comment info in database
class CommentService {
  /// Creates a new user comment in database
  static createComment(String _postKey, String _commentIs, String commentPublisher) {
    Comment _comment = new Comment(
      postKey: _postKey,
      comment: _commentIs,
      publisher: commentPublisher,
    );
    try {
      FirebaseDatabase.instance
          .reference()
          .child("comments/$_postKey")
          .push()
          .set(_comment.toJson());
    } catch (e) {
      print('An unexpected error occured.\nError: $e');
    }
  }

  /// To retrieve user's whole comment from database
  static Future<List<Comment>> fetchComment(String postKey) async {
    List<Comment> commentList = [];
    var _readData = await FirebaseDatabase.instance
        .reference()
        .child("comments")
        .orderByChild("postKey")
        .equalTo(postKey)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        for (String commentKey in snapshot.value.keys.toList()) {
          Map comment = snapshot.value[commentKey];
          Comment.fromMap(comment, commentKey);
        }
      } else {
        return null;
      }
    });
    return commentList;
  }

  /// Delete user comment
  deleteComment(Comment comment, String postKey) {
    FirebaseDatabase.instance
        .reference()
        .child("comments/$postKey/${comment.commentKey}")
        .remove()
        .then((_) {
      print('Comment deleted');
    });
  }
}
