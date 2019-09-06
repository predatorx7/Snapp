import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status {
  // Use for Authentication
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  // Use for Checking Email
  CheckFailed,
  CheckingEmail,
  // Use for Registration
  Registering,
  UnRegistered,
  Registered
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  String _email;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  String get email => _email;

  /// Used for Signing in and providing authentication to UserRepo.
  /// Shows SnackBar on error with error message (That's why it needs Scaffold Key)
  Future<bool> signIn(
      String email, String password, GlobalKey<ScaffoldState> key) async {
    /// Check for userIds in database. Get it's email and use that to login. Else, follow.
    if (!email.contains('@')) email = email + '@instac.com';
    print('$email : $password');
    try {
      // Starting Authentication
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('App name: ${_auth.app.name}');
      // Will not return if error caught.
      return true;
    } catch (error) {
      var errorText;
      print(error);
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          errorText = "Email or Username is invalid";
          break;
        case 'ERROR_WRONG_PASSWORD':
          errorText = "Password is wrong";
          break;
        case 'ERROR_USER_NOT_FOUND':
          errorText = "Cannot find user";
          break;
        case 'ERROR_USER_DISABLED':
          errorText = "Account disabled";
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          errorText = "Too many requests";
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          errorText = "Operation not allowed";
          break;
        default:
          errorText = "Something went wrong";
      }
      key.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            errorText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      // Authentication failed
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> doesEmailExist(
      {String email, GlobalKey<ScaffoldState> key}) async {
    print('Testing $email');
    try {
      _status = Status.CheckingEmail;
      notifyListeners();

      /// Using wrong password to check email existence.
      await _auth.signInWithEmailAndPassword(
          email: email, password: 'test_password');
      print(_auth.app.name);
      // Logged in with fake password? Not possible. Don't allow fake password in registration.
      return null;
    } catch (error) {
      var errorText;
      print(error);
      switch (error.code) {
        case 'ERROR_USER_NOT_FOUND':
          // User not found! This email can be used for registration.
          errorText = 'User not found';
          _email = email;
          _status = Status.UnRegistered;
          notifyListeners();
          return false;
          break;
        case 'ERROR_WRONG_PASSWORD':
          errorText = 'Email already exists';
          break;
        case 'ERROR_INVALID_EMAIL':
          errorText = "Email or Username is invalid";
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          errorText = "Too many requests";
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          // If Sign in method disabled
          errorText = "Operation not allowed";
          break;
        case 'ERROR_USER_DISABLED':
        default:
          errorText = "Something went wrong";
          print(errorText);
      }
      _status = Status.CheckFailed;
      notifyListeners();
      key.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            errorText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return true;
    }
  }

  /// A work around to change page as unauthenticated user
  /// Make sure to add conditions & case for pages with their Statuses here and in _onAuthStateChanged() below
  void openPage({String page}) {
    switch (page) {
      case 'CheckEmail':
        _status = Status.CheckFailed;
        notifyListeners();
        break;
      case 'Register':
        _status = Status.UnRegistered;
        notifyListeners();
        break;
      default:
    }
  }

  /// Use for Signing up and providing authentication to UserRepo.
  /// Shows SnackBar on error with error message (That's why it needs Scaffold Key)
  Future<bool> signUp(
      String email, String password, GlobalKey<ScaffoldState> key) async {
    if (!email.contains('@')) email = email + 'instac.com';
    // CHECK FOR userID existence and get Email
    try {
      _status = Status.Registering;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (error) {
      var errorText;
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          errorText = "Email or Username is invalid";
          break;
        case 'ERROR_WRONG_PASSWORD':
          errorText = "Password is wrong";
          break;
        case 'ERROR_USER_NOT_FOUND':
          errorText = "Cannot find user";
          break;
        case 'ERROR_USER_DISABLED':
          errorText = "Account disabled";
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          errorText = "Too many requests";
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
        default:
          errorText = "Something went wrong";
      }
      key.currentState.showSnackBar(
        SnackBar(
          content: Text(errorText),
        ),
      );
      _status = Status.UnRegistered;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null &&
        (_status == Status.CheckingEmail || _status == Status.CheckFailed)) {
      // if Unauthenticated but checking email to enter registration process.
      _status = Status.CheckFailed;
    } else if (firebaseUser == null &&
        (_status == Status.Registering || _status == Status.UnRegistered)) {
      // if Unauthenticated but in registration process.
      _status = Status.UnRegistered;
    } else if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
