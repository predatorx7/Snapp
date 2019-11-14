import 'package:flutter/material.dart';

// Just for easy reference

class CommonImages {
  static const Image profilePic1 = Image(
    fit: BoxFit.contain,
    image: profilePicAsset,
  );

  static const Image profilePic2 = Image(
    fit: BoxFit.contain,
    height: 20,
    width: 20,
    image: profilePicAsset,
  );

  static const AssetImage profilePicAsset =
      AssetImage('assets/icon/ic_profile.png');

  static const Image settingsIcon = Image(
    image: settingsIconAsset,
  );

  static const AssetImage settingsIconAsset =
      AssetImage('assets/res_icons/settingsOutline.png');

  static const Image directOutline = Image(
    image: directOutlineAsset,
    fit: BoxFit.contain,
    width: 25.0,
    height: 25.0,
  );
  static const Image directOutline2 = Image(
    image: directOutlineAsset,
  );

  static const AssetImage directOutlineAsset =
      AssetImage('assets/res_icons/directOutline.png');

  static const Image cameraOutline = Image(
    image: cameraOutlineAsset,
  );

  static const AssetImage cameraOutlineAsset =
      AssetImage('assets/res_icons/cameraOutline.png');

  static const Image logo = Image(
    image: logoAsset,
  );

  static const AssetImage logoAsset = AssetImage('assets/res_image/logo.png');

  static const Image homeOutline = Image(
    image: homeOutlineAsset,
  );

  static const AssetImage homeOutlineAsset =
      AssetImage('assets/res_icons/homeOutline.png');

  static const Image homeFilled = Image(
    image: homeFilledAsset,
  );

  static const AssetImage homeFilledAsset =
      AssetImage('assets/res_icons/homeFilled.png');

  static const Image searchOutline = Image(
    image: searchOutlineAsset,
  );

  static const AssetImage searchOutlineAsset =
      AssetImage('assets/res_icons/searchOutline.png');

  static const Image searchFilled = Image(
    image: searchFilledAsset,
  );

  static const AssetImage searchFilledAsset =
      AssetImage('assets/res_icons/searchFilled.png');

  static const Image newPost = Image(
    image: newPostAsset,
  );

  static const AssetImage newPostAsset =
      AssetImage('assets/res_icons/newPost.png');

  static const Image heartOutline = Image(
    image: heartOutlineAsset,
  );

  static const AssetImage heartOutlineAsset =
      AssetImage('assets/res_icons/heartOutline.png');

  static const Image heartFilled = Image(
    image: heartFilledAsset,
  );

  static const AssetImage heartFilledAsset =
      AssetImage('assets/res_icons/heartFilled.png');

  static const Image userOutline = Image(
    image: userOutlineAsset,
  );

  static const AssetImage userOutlineAsset =
      AssetImage('assets/res_icons/userOutline.png');

  static const Image userFilled = Image(
    image: userFilledAsset,
  );

  static const AssetImage userFilledAsset =
      AssetImage('assets/res_icons/userFilled.png');

  // res_image
  static const Image logoBlack = Image(
    image: logoBlackAsset,
  );

  static const AssetImage logoBlackAsset =
      AssetImage('assets/res_image/logo_black.png');

  static const Image logoGradient = Image(
    image: logoGradientAsset,
  );

  static const AssetImage logoGradientAsset =
      AssetImage('assets/res_image/logo_circle.png');

  static const Image circleGradient = Image(
    image: logoGradientAsset,
  );

  static const AssetImage circleGradientAsset =
  AssetImage('assets/res_image/circle_gradient.png');
}
