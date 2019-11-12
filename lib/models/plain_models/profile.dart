import 'package:firebase_database/firebase_database.dart';

/// Serializes user profile information
/// to retrieve Profile information from database snapshot using adapters & services.
class Profile {
  String key;

  /// User Bio
  String bio;

  /// Replace "." after @ in email with ":" if uploading email as Key
  String email;

  /// List of followers
  List<dynamic> followers;

  /// List of people followed.
  List<dynamic> follows;

  /// Full Name of User.
  String fullName;

  /// User's gender.
  /// Gender Should be: Male, Female, <custom>, and Prefer not to say.
  String gender;

  /// List of postIds of posts posted by this user.
  List<dynamic> posts;

  /// List of storyId of stories by this user.
  List<dynamic> stories;

  /// ProfileImageId for this user.
  String profileImage;

  /// Firebase uid of this user.
  String uid;

  /// App username of this user.
  String username;

  /// Raw data map
  Map<dynamic, dynamic> dataMap;

  Profile(
      {this.bio,
      this.email,
      this.followers,
      this.follows,
      this.fullName,
      this.gender,
      this.posts,
      this.profileImage,
      this.stories,
      this.uid,
      this.username});

  List _getFromArray(data) {
    // When creating a child by pushing, only the last post pushed has a unique key, the previous ones are altered with incremented numbers on push. Thus
    // on removing the last child, list is parsed instead of a Map. The below workaround try/catch deals with it.
    List listIs;
    try {
      Map rawPostsMap = data ?? {};
      listIs = rawPostsMap.values.toList() ?? [];
    } catch (e) {
      List rawPostsList = data ?? [];
      listIs = rawPostsList ?? [];
    }
    return listIs;
  }

  Profile.fromMap(DataSnapshot snapshotData) {
    Map mainData = snapshotData.value;
    key = mainData['uid'];
    print('SNapshot: ${snapshotData.value.toString()}');
    uid = mainData['uid'] ?? '';
    bio = mainData['bio'] ?? '';
    email = mainData['email'] ?? '';
    followers = _getFromArray(mainData['followers']);
    print(followers.toString());
    follows = _getFromArray(mainData['follows']);
    fullName = mainData['fullName'] ?? '';
    gender = mainData['gender'] ?? '';
    posts = _getFromArray(mainData['posts']);
    profileImage = mainData['profileImage'] ?? '';
    stories = _getFromArray(mainData['stories']);
    username = mainData['username'] ?? '';
  }

  Profile.createFromMap(Map mainData) {
//    key = mainData['uid'] ?? '';
//    uid = mainData['uid'] ?? '';
//    bio = mainData['bio'] ?? '';
//    email = mainData['email'] ?? '';
//    username = mainData['username'] ?? '';
//    followers = mainData['followers'] ?? [];
//    follows = _tryAssign('follows', mainData, []);
//    fullName = mainData['fullName'] ?? '';
//    gender = mainData['gender'] ?? '';
//    posts = mainData['posts'] ?? [];
//    profileImage = mainData['profileImage'] ?? '';
//    stories = mainData['stories'] ?? [];

    uid = mainData['uid'] ?? '';
    bio = mainData['bio'] ?? '';
    email = mainData['email'] ?? '';
    followers = _getFromArray(mainData['followers']);
    follows = _getFromArray(mainData['follows']);
    fullName = mainData['fullName'] ?? '';
    gender = mainData['gender'] ?? '';
    posts = _getFromArray(mainData['posts']);
    profileImage = mainData['profileImage'] ?? '';
    stories = _getFromArray(mainData['stories']);
    username = mainData['username'] ?? '';
  }

  _tryAssign(String key, Map data, replace) {
    dynamic x;
    try {
      x = data[key];
    } catch (e) {
      x = replace;
    }
    return x;
  }

  Profile.fromValue(Map mainData) {
    uid = _tryAssign('uid', mainData, '');
    bio = _tryAssign('bio', mainData, '');
    email = _tryAssign('email', mainData, '');
    followers = _getFromArray(mainData['followers'] ?? []);
    follows = _getFromArray(mainData['follows'] ?? []);
    fullName = _tryAssign('fullName', mainData, '');
    gender = _tryAssign('gender', mainData, '');
    posts = _getFromArray(mainData['posts'] ?? []);
    profileImage = _tryAssign('profileImage', mainData, '');
    stories = _getFromArray(mainData['stories'] ?? []);
    username = _tryAssign('username', mainData, '');
  }

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "bio": bio,
      "email": email,
      "followers": followers,
      "follows": follows,
      "fullName": fullName,
      "gender": gender,
      "posts": posts,
      "profileImage": profileImage,
      "stories": stories,
      "uid": uid,
      "username": username
    };
  }
}

/// Changes "." with ":" in emails which are meant to be used as keys as Firebase Realtime Database doesn't accept keys which have .$[]#
class KeyEmail {
  List<String> modified;

  /// Returns email in format "sample@sample:com" from "sample@sample.com"
  String getEmailAsValidKey(String email) {
    return email.replaceAll(".", ":");
  }

  /// Returns email in format "sample@sample.com" from "sample@sample:com"
  String getEmailfromKey(String keyEmail) {
    return keyEmail.replaceAll(":", ".");
  }
}

// void main() {
//   var emailHandle = KeyEmail();
//   print(Profile(
//           email: 'smushaheed@gmail.com',
//           fullName: 'Syed Mushaheed',
//           gender: 'Prefer Not to say',
//           uid: 'kjsbcjBS8',
//           username: 'SMUSHAHEED')
//       .toJson());
//   print(' . => : & : => .');
//   print(emailHandle.getEmailAsValidKey('smushaheed@outlook.com'));
//   print(emailHandle.getEmailfromKey('smushaheed@outlook:com'));
// }
