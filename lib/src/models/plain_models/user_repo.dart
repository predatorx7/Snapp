import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  CheckFailed,
  CheckingEmail,
  Registering,
  UnRegistered
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(
      String email, String password, GlobalKey<ScaffoldState> key) async {
    if (!email.contains('@')) email = email + '@instac.com';
    print('$email : $password');
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(_auth.app.name);
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
          backgroundColor: Colors.redAccent,
          content: Text(
            errorText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> doesEmailExist(
      {String email, GlobalKey<ScaffoldState> key}) async {
    if (!email.contains('@')) email = email + '@instac.com';
    print('Testing $email');
    try {
      _status = Status.CheckingEmail;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email, password: 'test_password');
      print(_auth.app.name);
    } catch (error) {
      var errorText;
      print(error);
      switch (error.code) {
        case 'ERROR_USER_NOT_FOUND':
          return false;
          break;
        case 'ERROR_INVALID_EMAIL':
          errorText = "Email or Username is invalid";
          break;
        case 'ERROR_WRONG_PASSWORD':
          errorText = 'Email already exists';
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

  Future<bool> signUp(
      String email, String password, GlobalKey<ScaffoldState> key) async {
    var result;
    if (!email.contains('@')) email = email + 'instac.com';
    // CHECK FOR USERID existense and get Email
    try {
      _status = Status.Registering;
      notifyListeners();
      result = await _auth.createUserWithEmailAndPassword(
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
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
