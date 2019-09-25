import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HandleSnapshot extends StatefulWidget {
  final Stream<DataSnapshot> future;
  final Widget Function(BuildContext, AsyncSnapshot<DataSnapshot>) builder;

  const HandleSnapshot({Key key, this.future, this.builder}) : super(key: key);

  @override
  _HandleSnapshotState createState() => _HandleSnapshotState();
}

class _HandleSnapshotState extends State<HandleSnapshot> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.future,
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            return new Text('Result: ${snapshot.data}');
          case ConnectionState.none:
            return new Text('Result: ${snapshot.data}');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              if (!snapshot.hasData) {
                return Text(':(');
              } else {
                return widget.builder(context, snapshot);
              }
            }
        }
      },
    );
  }
}
