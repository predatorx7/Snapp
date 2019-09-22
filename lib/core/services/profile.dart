import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/namegen.dart';
import '../../models/plain_models/profile.dart';

/// Provides CRUD operations with profile info in database
class ProfileService {
  FirebaseDatabase _database = new FirebaseDatabase();

  /// Creates a new user profile in database
  Future createProfile(_fullName, FirebaseUser user) async {
    print('Creating profile for $_fullName');
    String _username;
    var getAvailableUsername = GenerateUsername();
    _username = await getAvailableUsername.getUserID(user.email, _fullName);
    Profile _profile = new Profile(
        email: user.email,
        fullName: _fullName,
        gender: 'Prefer Not to say',
        uid: user.uid,
        username: _username);

    print('Pushing profile to database: ${_profile.toJson()}');

    try {
      await _database
          .reference()
          .child("profiles/${user.uid}")
          .set(_profile.toJson());
      print(
          'Profile creation successful: username: $_username for ${user.email}');
    } catch (e) {
      print('An unexpected error occured.\nError: $e');
    }
  }

  Future<DataSnapshot> getProfileSnapshot(FirebaseUser user) async {
    print(user);
    var _readData = await _database
        .reference()
        .child("profiles")
        .orderByChild("email")
        .equalTo(user.email)//.reference()
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        print('Snapshot: ${snapshot.value}');
        return snapshot;
        //use Profile.fromMap(snapshot.value, user.uid);
      } else {
        print('Snapshot: ${snapshot.value}');
        return snapshot.value;
      }
    });
    return _readData;
  }

  /// Update changes to profile
  Future<void> updateProfile(Profile profile) async {
    print('updating $profile');
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
