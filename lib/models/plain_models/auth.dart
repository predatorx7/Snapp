import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/services/registration_service.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthNotifier with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  AuthNotifier.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }
  FirebaseAuth get authInfo => _auth;
  Status get status => _status;
  FirebaseUser get user => _user;

  /// Update Auth Status Manually
  void setAuthStatus(Status authStatus) {
    _status = authStatus;
    notifyListeners();
  }

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

  Future<bool> signUp(email, fullName, password, context, username) async {
    bool result = await RegisterService()
        .signUp(email, fullName, password, context, username);
    result ? print('user created') : print('Something unexpected happened');
    notifyListeners();
    return true;
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    // Returning a future to allow await to let the listeners work properly.
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    print('[Auth] Noticed Auth Changes: ${firebaseUser.toString()}');
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
