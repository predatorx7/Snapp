import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/src/pages/comments.dart';
import 'package:instagram/src/pages/final_signup.dart';
import 'package:instagram/src/pages/login.dart';
import 'package:instagram/src/pages/signup.dart';
import 'package:instagram/src/pages/signup_success.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: ListView(
        // shrinkWrap: true,
        children: <Widget>[
          FlatButton(
            child: Text('Comments Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommentsPage()),
              );
            },
          ),
          FlatButton(
            child: Text('Login Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          FlatButton(
            child: Text('Signup Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
          ),
          FlatButton(
            child: Text('Final Signup Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FinalSignUpPage(),
                ),
              );
            },
          ),
          FlatButton(
            child: Text('Signup Success'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpSuccess(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
