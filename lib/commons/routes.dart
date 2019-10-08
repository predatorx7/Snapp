import 'package:flutter/material.dart';
import 'package:instagram/models/view_models/change_username.dart';
import 'package:instagram/ui/screens/edit_profile.dart';
import '../ui/screens/registeration/change_username.dart';
import 'routing_constants.dart';
import '../models/view_models/login_page.dart';
import '../models/view_models/message_notification.dart';
import '../models/view_models/signup_page.dart';
import '../ui/screens/instagram.dart';
import '../ui/screens/login.dart';
import '../ui/screens/profile_page.dart';
import '../ui/screens/registeration/signup_page.dart';
import '../ui/screens/post_upload.dart';
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
      return MaterialPageRoute(
        settings: RouteSettings(isInitialRoute: true),
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              builder: (context) => SignUpViewModel(),
            ),
            ChangeNotifierProvider(
              builder: (context) => SignUp2ViewModel(),
            ),
            ChangeNotifierProvider(
              builder: (context) => SignUp3ViewModel(),
            ),
          ],
          child: new SignUpPage(),
        ),
      );
    case ChangeUsernameRoute:
      return MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: SignUp3ViewModel(),
            ),
            ChangeNotifierProvider(
              builder: (context) => ChangeUsernameViewModel(),
            ),
          ],
          child: new ChangeUsername(
            authenticated: settings.arguments ?? false,
          ),
        ),
      );
    case SignUpStep2Route:
      return MaterialPageRoute(
        settings: RouteSettings(isInitialRoute: true),
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              builder: (context) => SignUp2ViewModel(),
            ),
            ChangeNotifierProvider(
              builder: (context) => ChangeUsernameViewModel(),
            ),
          ],
          child: new SignStep2(
            email: settings.arguments,
          ),
        ),
      );
    case UploadPostRoute:
      return MaterialPageRoute(
        builder: (context) =>  PostUploadPage()
      );
    case ProfilePageRoute:
      return MaterialPageRoute(
        builder: (context) => ProfilePage(),
      );
    case EditProfileRoute:
      return MaterialPageRoute(
        builder: (context) => EditProfile(),
      );
    default:
      return MaterialPageRoute(builder: (context) => Splash());
  }
}
