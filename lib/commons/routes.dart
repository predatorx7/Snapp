import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/view_models/login_page.dart';
import 'package:instagram/models/view_models/message_notification.dart';
import 'package:instagram/ui/screens/instagram.dart';
import 'package:instagram/ui/screens/login.dart';
import 'package:instagram/ui/screens/profile_page.dart';
import 'package:instagram/ui/screens/registeration/signup_page.dart';
import 'package:instagram/ui/screens/upload.dart';
import 'package:provider/provider.dart';

import '../main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Root());
    case LoginRoute:
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          builder: (context) => LoginPageViewModel(),
          child: new LoginPage(),
        ),
      );
    case HomeRoute:
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          builder: (context) => MessageNotificationModel(),
          child: Instagram(),
        ),
      );
    case SignUpRoute:
      return MaterialPageRoute(builder: (context) => SignUpPage());
    case SignUpStep2Route:
      return MaterialPageRoute(
        builder: (context) => SignStep2(
          email: settings.arguments,
        ),
      );
    case UploadPostRoute:
      return MaterialPageRoute(builder: (context) => UploadPage());
    case ProfilePageRoute:
      return MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(builder: (_) => InfoModel()),
            // ChangeNotifierProvider(builder: (_) => AuthNotifier.instance()),
          ],
          child: ProfilePage(),
        ),
      );
    default:
      return MaterialPageRoute(builder: (context) => Splash());
  }
}
