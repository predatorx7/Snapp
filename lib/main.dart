import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/test.dart';

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
        ),
        // primarySwatch: Colors.grey,
        // primaryColor: Color(colorPrimary),
        // accentColor: Color(colorAccent),
        // primaryColorDark: Color(colorPrimaryDark),
        splashColor: Colors.transparent,
        // // textTheme: buildTextTheme(base.textTheme, kWhite),
        // inputDecorationTheme: InputDecorationTheme(
        //   fillColor: Colors.grey,
        //   border: OutlineInputBorder(),
        //   // labelStyle: TextStyle(color: kYellow, fontSize: 24.0),
        // ),
      ),
      home: TestPage(),
    );
  }
}
