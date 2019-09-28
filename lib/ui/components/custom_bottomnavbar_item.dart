import 'package:flutter/widgets.dart';

BottomNavigationBarItem icBottomNavBarItem(
    {String iconImageAddress, String activeIconImageAddress}) {
  return BottomNavigationBarItem(
    title: Container(height: 0.0),
    icon: Image(
      image: AssetImage(iconImageAddress),
    ),
    activeIcon: Image(
      image: AssetImage(activeIconImageAddress),
    ),
  );
}
