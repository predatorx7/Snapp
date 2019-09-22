import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'profile.dart';

class RegisterService {
  FirebaseAuth _auth;
  Future<bool> doesEmailExist({String email, BuildContext context}) async {
    print('Testing $email');
    try {
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
      Scaffold.of(context).showSnackBar(
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

  /// Use for Signing up and providing authentication to UserRepo.
  /// Shows SnackBar on error with error message (That's why it needs Scaffold Key)
  Future<bool> signUp(String email, String fullName, String password,
      BuildContext context, FirebaseUser user) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await ProfileService().createProfile(fullName, user);
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
        default:
          errorText = "Something went wrong";
      }
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(errorText),
        ),
      );
      return false;
    }
  }
}
