import 'dart:convert' as JSON;

// { "StudentID": "89296", "studentName": "XYZ", "lec": "python", "time": "0700:0900" }
String jsonShow(jsonAsString) {
  final scannedJson = JSON.jsonDecode(jsonAsString);
  var studentId = scannedJson['StudentID'],
      studentName = scannedJson['studentName'],
      lec = scannedJson['lec'],
      time = (scannedJson['time']).split(':');
  return "Gr No.: $studentId\nName: $studentName\nTime: From ${time[0]} to ${time[1]}";
}

class Validator3000 {
  String isEmailValid(String email) {
    if (isNotEmptyOrNull(email)) {
      if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
              .hasMatch(email) ==
          false) {
        return 'The email address you entered is invalid.';
      }
    } else {
      return 'Email can\'t be empty';
    }
  }

  String isNameValid(String name) {
    if (isNotEmptyOrNull(name)) {
      if (RegExp(r'^[A-Za-z ]+$').hasMatch(name) == false) {
        return 'Are you sure that you\'ve entered your name correctly?';
      }
    } else {
      return 'Name can\'t be empty';
    }
  }

  bool isNumberValid(String number) {
    // Maybe useful?
    RegExp numberRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    return numberRegExp.hasMatch(number);
  }

  String isPasswordValid(String password) {
    if (isNotEmptyOrNull(password)) {
      if (password.length < 8) {
        return 'Password too short.';
      }
    } else
      return 'Password can\'t be empty';
  }

  String isPasswordStrong(String password) {
    // Password Strength
    // using this is a pain to users. just for future's sake
    if (RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password)) {
      //
    } else if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
        .hasMatch(password)) {
      //
    } else if (RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(password)) {
      //
    } else if (RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
        .hasMatch(password)) {
      //
    } else {
      return 'Password is weak';
    }
  }

  bool isNotEmptyOrNull(String text) {
    if (text == null) {
      return false;
    } else if (text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
