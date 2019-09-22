import 'package:flutter/widgets.dart';

/// Override Back Button to not discard passed Widget. Surround your scaffold widget with it, it returns a false value to the onWillPop call. False tells the system they don’t have to handle the scope pop call.
class NoBack extends StatelessWidget {
  final Widget widget;

  const NoBack({Key key, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: widget,
    );
  }
}
