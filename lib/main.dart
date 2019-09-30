import 'package:firebase_auth/firebase_auth.dart';
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
import 'models/view_models/login_page.dart';

void main() {
  /// To keep app in Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => AuthNotifier.instance(),
        ),
        ChangeNotifierProvider(
          builder: (context) => InfoModel(),
        ),
        // Needed for not letting new users go directly to the home
        ChangeNotifierProvider(
          builder: (context) => SignUpViewModel(),
        ),
      ],
      child: Root(),
    ),
  );
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      // Specify Initial route
      // initialRoute: '/',
      onGenerateRoute: generateRoute,
      home: Consumer(
        builder: (context, AuthNotifier userAuth, _) {
          switch (userAuth.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return ChangeNotifierProvider(
                builder: (context) => LoginPageViewModel(),
                child: new LoginPage(),
              );
            case Status.Authenticated:
              return Instagram();
            default:
              return new Text('Error');
          }
        },
      ),
      // home: StreamBuilder(
      //   stream: FirebaseAuth.instance.onAuthStateChanged,
      //   builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
      //     switch (snapshot.connectionState) {
      //       // When uninitialized
      //       case ConnectionState.waiting:
      //         return new Splash(data: snapshot);
      //       case ConnectionState.active:
      //         if (snapshot.hasData) {
      //           return new Instagram(user: snapshot.data);
      //         } else {
      //           return ChangeNotifierProvider(
      //             builder: (context) => LoginPageViewModel(),
      //             child: new LoginPage(),
      //           );
      //         }
      //         break;
      //       default:
      //         // Snapshot has Error
      //         return new Text('Error: ${snapshot.error}');
      //     }
      //   },
      // ),
    );
  }
}

class Splash extends StatelessWidget {
  final AsyncSnapshot<FirebaseUser> data;

  const Splash({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w900,
                  fontSize: 40),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 5),
              child: CircularProgressIndicator(),
            ),
            Text('wait')
          ],
        ),
      ),
    );
  }
}
