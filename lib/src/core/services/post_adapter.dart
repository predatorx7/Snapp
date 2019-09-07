import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/src/models/plain_models/post.dart';

/// Provides CRUD operations with post info in database
class PostAdapter {
  FirebaseDatabase _database = new FirebaseDatabase();

  /// Creates a new user post in database
  createPost(_imageURL, _username, FirebaseUser user) {
    Post _post = new Post(imageURL: _imageURL, publisher: user.uid);
    print('Pushing post to database: ${_post.toJson()}');

    try {
      _database.reference().child("posts").push().set(_post.toJson());
    } catch (e) {
      print('An unexpected error occured.\nError: $e');
    }
  }

  /// To retrieve user's whole post from database
  Future<Post> getPost(FirebaseUser user) async {
    var _readData = await _database
        .reference()
        .child("posts")
        .orderByChild("publisher")
        .equalTo(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        return Post.fromMap(snapshot.value, user.uid);
      } else {
        print('Couldn\'t get post');
        return null;
      }
    });
    return _readData;
  }

  /// Update changes to post
  Future<void> updatePost(Post post) async {
    if (post != null) {
      await _database
          .reference()
          .child("posts")
          .child(post.postKey)
          .set(post.toJson());
    }
  }

  /// Delete user post
  deletePost(String postKey) {
    _database.reference().child("posts").child(postKey).remove().then((_) {
      print("Delete post $postKey successful");
      // setState(() {
      //   // SetState if no listeners
      // });
    });
  }
}