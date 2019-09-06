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
  List<String> followers;

  /// List of people followed.
  List<String> follows;

  /// Full Name of User.
  String fullName;

  /// User's gender.
  /// Gender Should be: Male, Female, <custom>, and Prefer not to say.
  String gender;

  /// List of postIds of posts posted by this user.
  List<String> posts;

  /// List of storyId of stories by this user.
  List<String> stories;

  /// ProfileImageId for this user.
  String profileImage;

  /// Firebase uid of this user.
  String uid;

  /// App username of this user.
  String username;

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

  Profile.fromMap(DataSnapshot snapshot, String uid)
      : key = snapshot.key,
        uid = uid ?? '',
        bio = snapshot.value['bio'] ?? '',
        email = snapshot.value['email'] ?? '',
        followers = snapshot.value['followers'] ?? '',
        follows = snapshot.value['follows'] ?? '',
        fullName = snapshot.value['fullName'] ?? '',
        gender = snapshot.value['gender'] ?? '',
        posts = snapshot.value['posts'] ?? '',
        profileImage = snapshot.value['profileImage'] ?? '',
        stories = snapshot.value['stories'] ?? '',
        username = snapshot.value['username'] ?? '';

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
