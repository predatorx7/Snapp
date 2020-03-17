import 'package:flutter/material.dart';
import 'dart:async';

Future watchedTask({
  @required Future task,
  @required Duration timeLimit,
  GlobalKey<ScaffoldState> key,
  @required String errorText,
  bool showSnackBar = true,
}) async {
  Future value;

  value = await task.timeout(timeLimit, onTimeout: () async {
    print(errorText);
    if (showSnackBar)
      key.currentState.showSnackBar(SnackBar(content: Text(errorText)));
    return Null;
  });
  return value;
}
