import 'dart:convert';

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

  Profile.fromMap(DataSnapshot snapshotData, String uid) {
    key = snapshotData.value.keys.first;
    var mainData = snapshotData.value[key];
    uid = mainData['uid'] ?? '';
    bio = mainData['bio'] ?? '';
    email = mainData['email'] ?? '';
    followers = mainData['followers'] ?? [''];
    follows = mainData['follows'] ?? [''];
    fullName = mainData['fullName'] ?? '';
    gender = mainData['gender'] ?? '';
    posts = mainData['posts'] ?? [''];
    profileImage = mainData['profileImage'] ?? '';
    stories = mainData['stories'] ?? [''];
    username = mainData['username'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
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
