import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/pages/dashboard.dart';
import 'package:instagram/src/pages/final_signup.dart';
import 'package:instagram/src/pages/login.dart';
import 'package:instagram/src/pages/signup.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(
        cursorColor: Colors.teal,
        textSelectionColor: Color(0x550077ff),
        textSelectionHandleColor: Colors.teal,
        primaryTextTheme: TextTheme(title: TextStyle(color: Color(0xff262626))),
        appBarTheme: AppBarTheme(
          elevation: 2,
          brightness: Brightness.light,
          color: Colors.grey[100],
          iconTheme: IconThemeData(color: Colors.black),
        ),
        splashColor: Colors.transparent,
      ),
      home: ChangeNotifierProvider(
        builder: (_) => UserRepository.instance(),
        child: Consumer(
          builder: (context, UserRepository user, _) {
            switch (user.status) {
              case Status.Uninitialized:
                return Splash();
              case Status.Unauthenticated:
              case Status.Authenticating:
                return LoginPage();
              case Status.Authenticated:
                return Dashboard(user: user.user);
              case Status.UnRegistered:
              case Status.Registering:
                return FinalSignUpPage();
              case Status.CheckFailed:
              case Status.CheckingEmail:
                return SignUpPage();
            }
          },
        ),
      ),
      // home: TestPage(),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "WELCOME",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w900, fontSize: 40),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
