import 'package:flutter/widgets.dart';

class StringConstant extends InheritedWidget {
  static StringConstant of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StringConstant>();

  const StringConstant({Widget child, Key key}) : super(key: key, child: child);
  final String contantStringExample = '';

  @override
  bool updateShouldNotify(StringConstant old) => false;
}
