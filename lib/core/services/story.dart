import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'profile.dart';
import '../../models/plain_models/profile.dart';
import '../../models/plain_models/story.dart';

/// Provides CRUD operations with story info in database
class StoryService {
  FirebaseDatabase _database = new FirebaseDatabase();

  /// Creates a new user story in database
  void createStory(
      _imageURL, String uid, int time, String username) async {
    Story _story = new Story(
      imageURL: _imageURL,
      publisher: uid,
      creationTime: time,
      publisherUsername: username,
    );
    print('Pushing post to database: ${_story.toJson()}');

    try {
      _database.reference().child("stories/$uid").push().set(_story.toJson());
      DataSnapshot snapshot = await ProfileService().getProfileSnapshot(uid);
      Profile data = Profile.fromMap(snapshot);
      ProfileService().updateProfile(data);
      if (data != null) {
        await _database
            .reference()
            .child("profiles")
            .child(data.key)
            .child('stories')
            .push()
        // Reference to post as time to help in provide fuzzy time, fetching post and sorting based on time.
            .set(_story.creationTime);
      }
      print('[Story Service] Story creation: successful');
    } catch (e) {
      print(
          '[Story Service] Story creation: An unexpected error occured.\nError: $e');
    }
  }


  /// To retrieve user's whole story from database
  Future<Story> getStory(FirebaseUser user) async {
    var _readData = await _database
        .reference()
        .child("stories")
        .orderByChild("publisher")
        .equalTo(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        return Story.fromMap(snapshot.value, user.email);
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
