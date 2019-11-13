import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      _database.reference().child("posts/$uid").push().set(_post.toJson());
      print('[Post Service] Post creation: successful');
    } catch (e) {
      print(
          '[Post Service] Post creation: An unexpected error occured.\nError: $e');
    }
  }

  // Returns int which is time of creation and ID of post for this user
  Future getPostList(String uid) async {
    DataSnapshot snapshot = await ProfileService().getProfileSnapshot(uid);
    Profile data = Profile.fromDataSnapshot(snapshot);
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
  static Future<void> deletePost(Post metadata) async {
    String postKey = metadata.postKey;
    String publisher = metadata.publisher;
    var database = FirebaseDatabase().reference();
    await database.child('posts/$publisher/$postKey').remove();
    print('[Post Service] Post $postKey by $publisher has been deleted');
    await deleteFile(metadata);
  }

  Future uploadFile(
      File _image, String uid, String caption, String username) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('posts/$uid/${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then(
      (fileURL) {
        PostService().createPost(fileURL, uid, caption, time, username);
      },
    );
  }

  static Future deleteFile(Post post) async {
    try {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('posts/${post.publisher}/${post.creationTime}');
      await storageReference.delete();
      print('File Delete');
    } on Exception catch (e) {
      print('Could not delete file: $e');
    }
  }
}
