import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/src/models/plain_models/profile.dart';
import 'package:instagram/src/ui/components/handle_view_show.dart';

class HomePage extends StatefulWidget {
  final Profile profile;

  const HomePage({Key key, this.profile}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = new FirebaseDatabase().reference();
  List followerList;

  @override
  Widget build(BuildContext context) {
    if (widget.profile == null) {
      return Center(
        child: Text('No Posts'),
      );
    } else {
      followerList = widget.profile.followers;
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return HandleViewSnapshot(
            future: _databaseReference
                .child('posts/${followerList[index]}')
                .orderByChild("creationTime")
                .onValue
                .last
                .then((Event onValue) {
              return onValue.snapshot;
            }),
            builder: (BuildContext context,
                AsyncSnapshot<DataSnapshot> asyncSnapshot) {
              return Text(asyncSnapshot.data.value);
            },
          );
        },
      );
    }
  }
}
