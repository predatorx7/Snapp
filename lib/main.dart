import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/commons/routes.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/view_models/signup_page.dart';
import 'package:instagram/ui/screens/instagram.dart';
import 'package:instagram/ui/screens/login.dart';
import 'package:provider/provider.dart';
import 'models/plain_models/auth.dart';
import 'models/plain_models/information.dart';
import 'ui/screens/registeration/signup_page.dart';

void main() {
  /// To keep app in Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => AuthNotifier.instance()),
        ChangeNotifierProvider(builder: (context) => InfoModel()),
        // Needed for not letting new users go directly to the home
        ChangeNotifierProvider(builder: (context) => SignUpModel()),
      ],
      child: Root(),
    ),
  );
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var signUp = Provider.of<SignUpModel>(context);
    return MaterialApp(
      theme: mainTheme,
      // initialRoute: '/',
      onGenerateRoute: generateRoute,
      home: Consumer(
        builder: (context, AuthNotifier user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
              break;
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
              break;
            case Status.Authenticated:
              if (signUp.signUpStatus == SignUpStatus.Uninitialized) {
                return Instagram();
              } else {
                return SignStep3();
              }
              break;
            default:
              return Splash();
          }
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "wait",
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
