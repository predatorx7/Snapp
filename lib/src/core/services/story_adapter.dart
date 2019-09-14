import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/src/core/services/profile_adapter.dart';
import 'package:instagram/src/models/plain_models/profile.dart';
import 'package:instagram/src/models/plain_models/story.dart';

/// Provides CRUD operations with story info in database
class StoryAdapter {
  FirebaseDatabase _database = new FirebaseDatabase();

  /// Creates a new user story in database
  createStory(_imageURL, String _storyIs, FirebaseUser user) async {
    Story _story = new Story(
      imageURL: _imageURL,
      publisher: user.uid,
    );
    print('Pushing story to database: ${_story.toJson()}');

    try {
      _database.reference().child("storys").push().set(_story.toJson());
      DataSnapshot snapshot = await ProfileAdapter().getProfileSnapshot(user);
      Profile data = Profile.fromMap(snapshot, user.uid);
      data.stories.add(_imageURL);
      ProfileAdapter().updateProfile(data);
    } catch (e) {
      print('An unexpected error occured.\nError: $e');
    }
  }

  /// To retrieve user's whole story from database
  Future<Story> getStory(FirebaseUser user) async {
    var _readData = await _database
        .reference()
        .child("storys")
        .orderByChild("publisher")
        .equalTo(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        return Story.fromMap(snapshot.value, user.uid);
      } else {
        print('Couldn\'t get story');
        return null;
      }
    });
    return _readData;
  }

  /// Update changes to story
  Future<void> updateStory(Story story) async {
    if (story != null) {
      await _database
          .reference()
          .child("storys")
          .child(story.storyKey)
          .set(story.toJson());
    }
  }

  /// Delete user story
  deleteStory(String storyKey) {
    _database.reference().child("storys").child(storyKey).remove().then((_) {
      print("Delete story $storyKey successful");
      // setState(() {
      //   // SetState if no listeners
      // });
    });
  }
}
