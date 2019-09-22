import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/models/plain_models/auth.dart';
import 'package:provider/provider.dart';

void main() {
  /// To keep app in Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => AuthNotifier.instance(),
      child: Consumer(
        builder: (context, AuthNotifier user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
              break;
            case Status.Unauthenticated:
            case Status.Authenticating:
              break;
            case Status.Authenticated:
              break;
            default:
          }
        },
      ),
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
