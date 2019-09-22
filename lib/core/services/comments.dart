import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/plain_models/comments.dart';

/// Provides CRUD operations with comment info in database
class CommentService {
  FirebaseDatabase _database = new FirebaseDatabase();

  /// Creates a new user comment in database
  createComment(_postKey, String _commentIs, FirebaseUser user) {
    Comment _comment = new Comment(
      postKey: _postKey,
      comment: _commentIs,
      publisher: user.uid,
    );
    print('Pushing comment to database: ${_comment.toJson()}');

    try {
      _database.reference().child("comments").push().set(_comment.toJson());
    } catch (e) {
      print('An unexpected error occured.\nError: $e');
    }
  }

  /// To retrieve user's whole comment from database
  Future<Comment> getComment(FirebaseUser user) async {
    var _readData = await _database
        .reference()
        .child("comments")
        .orderByChild("publisher")
        .orderByChild('creationTime')
        .equalTo(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        return Comment.fromMap(snapshot.value, user.uid);
      } else {
        print('Couldn\'t get comment');
        return null;
      }
    });
    return _readData;
  }

  /// Update changes to comment
  Future<void> updateComment(Comment comment) async {
    if (comment != null) {
      await _database
          .reference()
          .child("comments")
          .child(comment.commentKey)
          .set(comment.toJson());
    }
  }

  /// Delete user comment
  deleteComment(String commentKey) {
    _database
        .reference()
        .child("comments")
        .child(commentKey)
        .remove()
        .then((_) {
      print("Delete comment $commentKey successful");
      // setState(() {
      //   // SetState if no listeners
      // });
    });
  }
}
