import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/view_models/direct_message.dart';
import 'package:instagram/models/plain_models/visited_info.dart';
import 'package:instagram/repository/profile.dart';
import 'package:instagram/models/view_models/change_username.dart';
import 'package:instagram/models/view_models/edit_profile.dart';
import 'package:instagram/ui/screens/messaging/direct_message.dart';
import 'package:instagram/ui/screens/post/comments_page.dart';
import 'package:instagram/ui/screens/profile_pic_edit.dart';
import 'package:instagram/ui/screens/edit_profile.dart';
import 'package:instagram/ui/screens/visited/visited_profile_page.dart';
import '../ui/screens/registeration/change_username.dart';
import 'routing_constants.dart';
import '../models/view_models/login_page.dart';
import '../models/view_models/message_notification.dart';
import '../models/view_models/signup_page.dart';
import '../ui/screens/instagram.dart';
import '../ui/screens/login/login.dart';
import '../ui/screens/profile_page.dart';
import '../ui/screens/registeration/signup_page.dart';
import '../ui/screens/post/post_upload.dart';
import 'package:provider/provider.dart';

import '../main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Root());
    case LoginRoute:
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => LoginPageViewModel(),
          child: new LoginPage(),
        ),
      );

    case HomeRoute:
      return MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MessageNotificationModel(),
            ),
          ],
          child: Instagram(),
        ),
      );
    case SignUpRoute:
      return MaterialPageRoute(
        // settings: RouteSettings(isInitialRoute: true), //[stable]
        settings: RouteSettings(),
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SignUpViewModel(),
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
              value: SignUpViewModel(),
            ),
          ],
          child: ChangeUsername(
            authenticated: settings.arguments ?? false,
          ),
        ),
      );
    case SignUpStep2Route:
      return MaterialPageRoute(
        // settings: RouteSettings(isInitialRoute: true), //[stable]
        settings: RouteSettings(),
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SignUpViewModel(),
            ),
            ChangeNotifierProvider(
              create: (context) => ChangeUsernameViewModel(),
            ),
          ],
          child: new SignStep2(
            email: settings.arguments,
          ),
        ),
      );
    case UploadPostRoute:
      return MaterialPageRoute(builder: (context) => PostUploadPage());
    case ProfilePageRoute:
      return MaterialPageRoute(
        builder: (context) => ProfilePage(),
      );
    case EditProfileRoute:
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<EditProfileModel>(
          create: (context) => EditProfileModel(),
          child: EditProfile(),
        ),
      );
    case ChangeProfilePicRoute:
      return MaterialPageRoute(
        builder: (context) => ProfilePicEditPage(),
      );
    case SomeoneProfileRoute:
      Profile x = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<VisitedInfoModel>(
          create: (context) => VisitedInfoModel.setInfo(x),
          child: VisitedProfilePage(),
        ),
      );
    case CommentsPageRoute:
      return MaterialPageRoute(
        builder: (context) => CommentsPage(
          postData: settings.arguments,
        ),
      );
    case DirectMessagePageRoute:
      List args = settings.arguments;
      return CupertinoPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<DirectMessageModel>(
              create: (context) => DirectMessageModel.initialize(
                thisUser: args[0],
                thatUser: args[1],
              ),
            ),
            ChangeNotifierProvider<VisitedInfoModel>(
              create: (context) => VisitedInfoModel(
                args[1],
              ),
            ),
          ],
          child: DirectMessageScreen(),
        ),
      );
    default:
      return MaterialPageRoute(builder: (context) => Splash());
  }
}
