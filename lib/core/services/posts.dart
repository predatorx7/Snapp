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
      await _database
          .reference()
          .child("posts/$uid")
          .push()
          .set(_post.toJson());
      print('[Post Service] Post creation: successful');
    } catch (e) {
      print(
          '[Post Service] Post creation: An unexpected error occured.\nError: $e');
    }
  }


  static Future<Post> getPost(String postKey, String publisher) async {
    Post post;
    DataSnapshot dSnap = await FirebaseDatabase.instance
        .reference()
        .child('posts/$publisher/$postKey')
        .once();
    if (dSnap.value != null) {
      print('[Post Service] Retrieved post: ${dSnap.value.toString()}');
    }
    return post;
  }

  static Future<bool> doLike(Profile liker, Post post) async {
    DatabaseReference dr = FirebaseDatabase.instance.reference();
    try {
      await dr
          .child("posts/${post.publisher}/${post.postKey}/likes")
          .push()
          .set(liker.uid);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> unLike(Profile unliker, Post post) async {
    DatabaseReference dr = FirebaseDatabase.instance
        .reference()
        .child("posts/${post.publisher}/${post.postKey}/likes");
    try {
      await dr.once().then((DataSnapshot value) {
        print("Recieved this post likes ${value.value.toString()}");
        for (var i in value.value.keys.toList()) {
          if (value.value[i] == unliker.uid) {
            dr.child(i).remove();
            break;
          }
        }
      });
      return true;
    } catch (e) {
      return false;
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
