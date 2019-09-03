import 'dart:math';

String genUserID(String email, String name) {
  email = email.toLowerCase();
  name = name.toLowerCase();
  String userId;
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
  checkIdAvailablity(userIds);
  userIds = [];
  for (var i = 9; i < 20; i++) {
    targetText = email.substring(0, email.indexOf('@')) + '$i';
    userIds.add(targetText);
  }
  checkIdAvailablity(userIds);
  userIds = [];
  for (var i = 20; i < 50; i++) {
    targetText = email.substring(0, email.indexOf('@')) + '$i';
    userIds.add(targetText);
  }
  checkIdAvailablity(userIds);
  userIds = [];

  var listOfRandomNum = new List.generate(12, (_) => randomNum(50, 100));

  for (var numbers in listOfRandomNum) {
    targetText = email.substring(0, email.indexOf('@')) + '$numbers';
    userIds.add(targetText);
  }
  checkIdAvailablity(userIds);
}

bool checkIdAvailablity(List<String> userId) {
  print(userId);
}

List<dynamic> checkAvailability() {
  bool availability;
  String key;
  // Check Availability
  // If found will return true with key
  // If not found will return false with key as 0
  return [availability, key];
}

void main() {
  genUserID('smushaheed@outlook.com', 'Syed Mushaheed');
}
