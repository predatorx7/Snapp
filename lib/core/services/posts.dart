import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'profile.dart';
import '../../models/plain_models/post.dart';

import '../../models/plain_models/profile.dart';

/// Provides CRUD operations with post info in database
class PostService {
  FirebaseDatabase _database = new FirebaseDatabase();

  /// Creates a new user post in database
  void createPost(
      _imageURL, String uid, String caption, int time, String username) async {
    Post _post = new Post(
      imageURL: _imageURL,
      publisher: uid,
      description: caption,
      creationTime: time,
      publisherUsername: username,
    );
    print('Pushing post to database: ${_post.toJson()}');

    try {
      _database
          .reference()
          .child("posts/$uid")
          .push()
          .set(_post.toJson());
      DataSnapshot snapshot = await ProfileService().getProfileSnapshot(uid);
      Profile data = Profile.fromMap(snapshot);
      ProfileService().updateProfile(data);
      if (data != null) {
        await _database
            .reference()
            .child("profiles")
            .child(data.key)
            .child('posts')
            .push()
            // Reference to post as time to help in provide fuzzy time, fetching post and sorting based on time.
            .set(_post.creationTime);
      }
      print('[Post Service] Post creation: successful');
    } catch (e) {
      print(
          '[Post Service] Post creation: An unexpected error occured.\nError: $e');
    }
  }

  // Returns int which is time of creation and ID of post for this user
  Future getPostList(String uid) async {
    DataSnapshot snapshot = await ProfileService().getProfileSnapshot(uid);
    Profile data = Profile.fromMap(snapshot);
    ProfileService().updateProfile(data);
    var _readData = await _database
        .reference()
        .child("profiles")
        .child(data.key)
        .child('posts')
        .once();
    return _readData.value;
  }

  /// To retrieve user's whole post from database
  Future<Post> getPostByTime(FirebaseUser user) async {
    var _readData = await _database
        .reference()
        .child("posts")
        .orderByChild("publisher")
        .equalTo(user.uid)
        .once()
        .then(
      (DataSnapshot snapshot) {
        if (snapshot.value != null) {
          return Post.fromMap(snapshot.value);
        } else {
          print('Couldn\'t get post');
          return null;
        }
      },
    );
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
