import 'package:flutter/material.dart';
import 'package:instagram/src/core/values.dart';
import 'package:instagram/src/pages/comments.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(
          primaryTextTheme:
              TextTheme(title: TextStyle(color: Color(0xff262626))),
          appBarTheme: AppBarTheme(
            elevation: 2,
            brightness: Brightness.light,
            color: Colors.grey[100],
          ),
          primarySwatch: Colors.grey,
          primaryColor: Color(colorPrimary),
          accentColor: Color(colorAccent),
          primaryColorDark: Color(colorPrimaryDark),
          splashColor: Colors.transparent),
      home: CommentsPage(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
