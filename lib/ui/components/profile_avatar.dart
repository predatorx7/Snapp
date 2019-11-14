import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/assets.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:provider/provider.dart';

class ICProfileAvatar extends StatefulWidget {
  final FirebaseDatabase database;
  final String profileOf;
  final double size;

  /// Don't provide [profileOf] if setting this (profileURL could be null)
  final String profileURL;
  const ICProfileAvatar(
      {Key key, this.database, this.profileOf, this.size = 18, this.profileURL})
      : super(key: key);
  @override
  _ICProfileAvatarState createState() => _ICProfileAvatarState();
}

class _ICProfileAvatarState extends State<ICProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    if (widget.profileOf == null) {
      return CircleAvatar(
        radius: widget.size,
        backgroundColor: Colors.grey[200],
        backgroundImage: widget.profileURL?.isNotEmpty ?? false
            ? NetworkImage(
                widget.profileURL,
              )
            : null,
        child: Visibility(
          visible: widget.profileURL?.isEmpty ?? true,
          child: SizedBox(
            height: widget.size,
            width: widget.size,
            child: CommonImages.profilePic2,
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child('profiles')
            .orderByChild("uid")
            .equalTo(widget.profileOf)
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snap) {
          if (snap.hasData) {
            Profile temp = Profile.fromDataSnapshot(snap.data);
            String profURL = temp.profileImage;
            return CircleAvatar(
              radius: widget.size,
              backgroundColor: Colors.grey[200],
              backgroundImage: profURL?.isNotEmpty ?? false
                  ? NetworkImage(
                      profURL,
                    )
                  : null,
              child: Visibility(
                visible: profURL?.isEmpty ?? true,
                child: SizedBox(
                  height: widget.size,
                  width: widget.size,
                  child: CommonImages.profilePic2,
                ),
              ),
            );
          } else {
            return SizedBox(
              height: 28,
              width: 28,
              child: icProcessIndicator(context),
            );
          }
        },
      );
    }
  }
}
