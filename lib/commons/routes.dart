import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/ui/screens/instagram.dart';
import 'package:instagram/ui/screens/login.dart';
import 'package:instagram/ui/screens/registeration/signup_page.dart';

import '../main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Root());
    case LoginRoute:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => Instagram());
    case SignUpRoute:
      return MaterialPageRoute(builder: (context) => SignUpPage());
    case SignUpStep2Route:
      return MaterialPageRoute(builder: (context) => SignStep2());
    default:
      return MaterialPageRoute(builder: (context) => Splash());
  }
}
