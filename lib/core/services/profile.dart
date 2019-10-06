import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/namegen.dart';
import '../../models/plain_models/profile.dart';

/// Provides CRUD operations with profile info in database
class ProfileService {
  FirebaseDatabase _database = new FirebaseDatabase();

  /// Creates a new user profile in database
  Future createProfile(
      String _fullName, FirebaseUser user, String _username) async {
    print(
        '[Profile Service] Creating profile for Full Name: $_fullName, username: $_username');

    Profile _profile = new Profile(
        email: user.email,
        fullName: _fullName,
        gender: 'Prefer Not to say',
        uid: user.uid,
        username: _username);

    print(
        '[Profile Service] Pushing profile to database: ${_profile.toJson()}');

    try {
      await _database
          .reference()
          .child("profiles/${user.uid}")
          .set(_profile.toJson());
      print(
          '[Profile Service] Profile creation successful: username: $_username for ${user.email}');
    } catch (e) {
      print('[Profile Service] An unexpected error occured.\nError: $e');
    }
  }

  Future<String> autoUsername(String email, String fullName) async {
    String _username;
    var getAvailableUsername = GenerateUsername();
    _username = await getAvailableUsername.getUserID(email, fullName);
    return _username;
  }

  Future<DataSnapshot> getProfileSnapshot(String uid) async {
    print('[Profile Service] Providing profile of: $uid');
    var _readData = await _database
        .reference()
        .child("profiles")
        .orderByChild("uid")
        .equalTo(uid)
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

  Future<String> getUsernameByUID(String uid) async {
    print('[Profile Service] Providing username for: $uid');
    var _readData = await _database
        .reference()
        .child("profiles")
        .orderByChild("uid")
        .equalTo(uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        print('Snapshot: ${snapshot.value}');
        String username = Profile.fromMap(snapshot).username;
        return username;
        //use Profile.fromMap(snapshot.value, user.uid);
      } else {
        print('Snapshot: ${snapshot.value}');
        return snapshot.value['username'];
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
