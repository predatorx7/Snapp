import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/namegen.dart';
import '../../repository/profile.dart';

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
        '[Profile Service] Pushing profile to database: ${_profile.toMap()}');

    try {
      await _database
          .reference()
          .child("profiles/${user.uid}")
          .set(_profile.toMap());
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
        String username = Profile.fromDataSnapshot(snapshot).username;
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
  Future<bool> updateProfile(Profile profile) async {
    print('updating $profile');
    try {
      if (profile != null) {
        await _database
            .reference()
            .child("profiles")
            .child(profile.uid)
            .update(profile.toMap());
      }
    } catch (e) {
      print('[Profile Service] update profile: Error: $e');
      return false;
    }
    return true;
  }

  Future doFollow(Profile observer, String tofollow) async {
    try {
      await _database
          .reference()
          .child("profiles/$tofollow/followers")
          .push()
          .set(observer.uid);
      await _database
          .reference()
          .child("profiles/${observer.uid}/follows")
          .push()
          .set(tofollow);
    } catch (e) {}
  }

  doUnFollow(Profile observer, String toUnfollow) async {
    try {
      await _database
          .reference()
          .child("profiles/$toUnfollow/followers")
          .once()
          .then((DataSnapshot value) {
        print("Recieved this user's profile ${value.value.toString()}");
        for (var i in value.value.keys.toList()) {
          if (value.value[i] == observer.uid) {
            _database
                .reference()
                .child("profiles/$toUnfollow/followers/$i")
                .remove();
            break;
          }
        }
      });
      await _database
          .reference()
          .child("profiles/${observer.uid}/follows")
          .once()
          .then((DataSnapshot value) {
        print("Recieved observer's profile ${value.value.toString()}");
        for (var i in value.value.keys.toList()) {
          if (value.value[i] == toUnfollow) {
            _database
                .reference()
                .child("profiles/${observer.uid}/followers/$i")
                .remove();
            break;
          }
        }
      });
    } catch (e) {}
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
