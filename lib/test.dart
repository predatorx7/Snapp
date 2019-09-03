import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/src/pages/comments.dart';
import 'package:instagram/src/pages/final_signup.dart';
import 'package:instagram/src/pages/login.dart';
import 'package:instagram/src/pages/signup.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          RaisedButton(
            child: Text('Comments Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommentsPage()),
              );
            },
          ),
          RaisedButton(
            child: Text('Login Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          RaisedButton(
            child: Text('Signup Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
          ),
          RaisedButton(
            child: Text('Signup Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FinalSignUpPage(
                          emailId: 'smushaheed@test.com',
                        )),
              );
            },
          )
        ],
      ),
    );
  }
}
