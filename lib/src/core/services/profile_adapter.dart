import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/src/models/plain_models/profile.dart';

/// Provides CRUD operations with profile info in database
class ProfileAdapter {
  FirebaseDatabase _database = new FirebaseDatabase();

  /// Creates a new user profile in database
  createProfile(_fullName, _username, FirebaseUser user) {
    Profile _profile = new Profile(
        email: user.email,
        fullName: _fullName,
        gender: 'Prefer Not to say',
        uid: user.uid,
        username: _username);
    print('Pushing profile to database: ${_profile.toJson()}');

    try {
      _database.reference().child("profiles").push().set(_profile.toJson());
    } catch (e) {
      print('An unexpected error occured.\nError: $e');
    }
  }

  /// To retrieve user's whole profile from database
  Future<Profile> getProfile(FirebaseUser user) async {
    var _readData = await _database
        .reference()
        .child("profiles")
        .orderByChild("uid")
        .equalTo(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        return Profile.fromMap(snapshot.value, user.uid);
      } else {
        return null;
      }
    });
    return _readData;
  }

  /// Update changes to profile
  Future<void> updateProfile(Profile profile) async {
    if (profile != null) {
      await _database
          .reference()
          .child("profiles")
          .child(profile.key)
          .set(profile.toJson());
    }
  }

  /// Delete user profile
  deleteProfile(String profileKey) {
    _database
        .reference()
        .child("profiles")
        .child(profileKey)
        .remove()
        .then((_) {
      print("Delete $profileKey successful");
      // setState(() {
      //   // SetState if no listeners
      // });
    });
  }
}
