import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/routes.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/utils/transactions.dart';
import 'package:instagram/models/view_models/signup_page.dart';
import 'package:instagram/ui/screens/instagram.dart';
import 'package:instagram/ui/screens/login/login.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/plain_models/auth.dart';
import 'models/view_models/instagram.dart';
import 'models/plain_models/info.dart';
import 'models/view_models/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // To keep app in Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Setting up Notification Handler
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthNotifier.instance(),
        ),
        // Needed for not letting new users go directly to the home
        ChangeNotifierProvider(
          create: (context) => SignUpViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginPageViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => Transactions(),
        ),
      ],
      child: Root(),
    ),
  );
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<InstagramPaginationModel>(
      model: InstagramPaginationModel(),
      child: Consumer(
        builder: (context, AuthNotifier userAuth, _) {
          return MaterialApp(
            theme: mainTheme,
            onGenerateRoute: generateRoute,
            home: Builder(
              builder: (context) {
                switch (userAuth.status) {
                  case Status.Authenticated:
                    // Authenticated
                    return ChangeNotifierProvider(
                      create: (context) => InfoModel(userAuth.user.uid),
                      child: Instagram(user: userAuth.user),
                    );
                  // Unauthenticated
                  case Status.Uninitialized:
                    return Splash();
                  case Status.Unauthenticated:
                  case Status.Authenticating:
                    return LoginPage();
                  default:
                    return Splash();
                }
              },
            ),
          );
        },
      ),
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
            SizedBox(
              height: 50,
              width: 50,
              child: CommonImages.logoBlack,
            ),
          ],
        ),
      ),
    );
  }
}
