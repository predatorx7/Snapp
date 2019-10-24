import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/styles.dart';

class ICProfileAvatar extends StatefulWidget {
  final FirebaseDatabase database;
  final String profileOf;

  const ICProfileAvatar({Key key, this.database, this.profileOf})
      : super(key: key);
  @override
  _ICProfileAvatarState createState() => _ICProfileAvatarState();
}

class _ICProfileAvatarState extends State<ICProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.database
          .reference()
          .child('profiles')
          .orderByChild("uid")
          .equalTo(widget.profileOf)
          .once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snap) {
        if (snap.hasData) {
          String profURL = snap.data.value["profileImage"];
          return CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[200],
            child: profURL?.isNotEmpty ?? false
                ? Image.network(
                    profURL,
                  )
                : CommonImages.profilePic2,
          );
        } else {
          return icProcessIndicator(context);
        }
      },
    );
  }
}
