import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/models/plain_models/profile.dart';

Future<String> doesIdExists({@required String text}) async {
  print('Checking if $text exists in app database');
  try {
    print('[Check] Checking ID as Username');
    Query _databaseUsernameQuery = FirebaseDatabase.instance
        .reference()
        .child("profiles")
        .orderByChild("username");
    DataSnapshot snapshot = await _databaseUsernameQuery.equalTo(text).once();
    print('[Check] Snapshot Value: ${snapshot.value}');
    if (snapshot.value != null) {
      var profile = Profile.fromMap(snapshot);
      print('Profile found! ${profile.email}');
      return profile.email;
    }
  } catch (e) {
    print('[Check] Error: $e');
  }
  try {
    print('Checking ID as Email');
    /// Using wrong password to check email existence.
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: text, password: 'test_password');
  } catch (error) {
    print('[Check] Error: $error');
    switch (error.code) {
      case 'ERROR_WRONG_PASSWORD':
        return text;
        break;
      default:
        // User not found or maybe an error!
        print("Something went wrong");
        return null;
    }
  }
}
