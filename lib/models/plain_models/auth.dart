import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/registration_service.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

/// This model provides notifications of authentication & registration/login APIs
class AuthNotifier with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  void setUser(FirebaseUser aUser) {
    _user = aUser;
  }

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
      FirebaseAuth _otherAuth = FirebaseAuth.instance;
      await _otherAuth.signInWithEmailAndPassword(
          email: email, password: password);
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
          errorText = "Forgotten password for $email?";
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
      showDialog(
        context: key.currentContext,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      errorText,
                      style: actionTitleStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('[Alert Box] Popping Alert Box');
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: new Text(
                          'Try Again',
                          style: actionTapStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
    notifyListeners();
    return result;
  }

  Future signOut() async {
    await _auth.signOut();
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
    print('[Auth] Current Auth Status: ${_status.toString()}');
    try {
      notifyListeners();
    } catch (e) {
      print('[Auth] NotifyListeners() :(');
    }
  }
}
