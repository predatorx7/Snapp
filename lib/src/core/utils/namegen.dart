import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

// void main() {
//   print(genUserID('smushaheed@outlook.com', 'Syed Mushaheed'));
// }
class GenerateUsername {
  Query _databaseUsernameQuery =
      FirebaseDatabase().reference().child("profiles").orderByChild("username");

  Future<String> getUserID(String email, String name) async {
    email = email.toLowerCase();
    name = name.toLowerCase();
    String userId;
    String key;
    String targetText;
    List<String> targetList = List<String>(), userIds = List<String>();
    var rng = new Random();
    int randomNum(int min, int max) => min + rng.nextInt(max - min);
    int lenOfTargetList;
    userId = email.substring(0, email.indexOf('@'));
    userIds.add(userId);
    (name.contains(' ')) ? targetList = name.split(' ') : targetList = [name];
    lenOfTargetList = targetList.length;
    switch (lenOfTargetList) {
      case 1:
        userId = name;
        userIds.add(userId);
        break;
      case 2:
        userId = targetList[0].substring(0, 1) + targetList[1];
        userIds.add(userId);
        userId = targetList[0].substring(0, 1) + '.' + targetList[1];
        userIds.add(userId);
        userId = targetList[0] + '.' + targetList[1];
        userIds.add(userId);
        userId = targetList[1].substring(0, 1) + targetList[0];
        userIds.add(userId);
        userId = targetList[1] + '.' + targetList[0];
        userIds.add(userId);
        break;
      default:
    }
    key = await checkAvailability(userIds);
    if (key != null) {
      return key;
    }
    userIds = [];
    for (var i = 9; i < 20; i++) {
      targetText = email.substring(0, email.indexOf('@')) + '$i';
      userIds.add(targetText);
    }
    key = await checkAvailability(userIds);
    if (key != null) {
      return key;
    }
    userIds = [];
    for (var i = 20; i < 50; i++) {
      targetText = email.substring(0, email.indexOf('@')) + '$i';
      userIds.add(targetText);
    }
    key = await checkAvailability(userIds);
    if (key != null) {
      return key;
    }
    userIds = [];

    var listOfRandomNum = new List.generate(12, (_) => randomNum(50, 100));

    for (var numbers in listOfRandomNum) {
      targetText = email.substring(0, email.indexOf('@')) + '$numbers';
      userIds.add(targetText);
    }
    key = await checkAvailability(userIds);
    if (key != null) {
      return key;
    }
    int randomNumber;
    for (var i = 100; key == null; i++) {
      randomNumber = randomNum(i, i + 50);
      targetText = email.substring(0, email.indexOf('@')) + '$randomNumber';
      key = await checkAvailability(userIds);
    }
    return key;
    // return userIds[randomNum(0, userIds.length - 1)];
  }

  Future<String> checkAvailability(List<String> _usernamesToCheck) async {
    /// Available username
    String key;
    for (var item in _usernamesToCheck) {
      key = await _databaseUsernameQuery
          .equalTo(item)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          return null;
        } else {
          return item;
        }
      });
      if (key != null) {
        print('Valid username found!: $key');
        break;
      }
    }
    return key;
  }
}
