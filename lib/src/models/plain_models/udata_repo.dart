class Profile {
  String username;
  String userId;
  String bio;
  String email;
  String gender;
  String profilePhoto;
  String followers;

  Profile(
      {this.username,
      this.userId,
      this.bio,
      this.email,
      this.gender,
      this.profilePhoto,
      this.followers});

  Profile.fromMap(Map snapshot, String username)
      : username = username ?? '',
        userId = snapshot['userId'] ?? '',
        bio = snapshot['bio'] ?? '',
        email = snapshot['email'] ?? '',
        gender = snapshot['gender'] ?? '',
        profilePhoto = snapshot['profilePhoto'] ?? '',
        followers = snapshot['followers'] ?? '';

  toJson() {
    return {
      "userId": userId,
      "bio": bio,
      "email": email,
      "gender": gender,
      "profilePhoto": profilePhoto,
      "followers": followers,
    };
  }
}
