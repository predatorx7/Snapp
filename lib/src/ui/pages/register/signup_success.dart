import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/src/core/services/profile_adapter.dart';
import 'package:instagram/src/core/utils/styles.dart';
import 'package:instagram/src/models/plain_models/profile.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/ui/pages/register/change_username.dart';
import 'package:instagram/src/ui/components/buttons.dart';
import 'package:provider/provider.dart';

class SignUpSuccess extends StatefulWidget {
  SignUpSuccess();
  @override
  _SignUpSuccessState createState() => _SignUpSuccessState();
}

class _SignUpSuccessState extends State<SignUpSuccess> {
  String userId, userEmail;
  Profile data;
  ProfileAdapter profileAdapter = ProfileAdapter();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'WELCOME TO INSTAGRAM,',
              style: headStyle(),
            ),
            SizedBox(
              height: 2,
            ),
            FutureBuilder( 
              future: profileAdapter.getProfileSnapshot(userRepo.user),
              builder:
                  (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('wait');
                  case ConnectionState.active:
                    return new Text('Result: ${snapshot.data}');
                  case ConnectionState.none:
                    return new Text('Result: ${snapshot.data}');
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else {
                      if (!snapshot.hasData) {
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {});
                        });
                        return Text(':(');
                      } else {
                        data =
                            Profile.fromMap(snapshot.data);
                        return new Text(
                          data.username,
                          style: bodyStyle(),
                        );
                      }
                    }
                }
              },
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Find people to follow and start sharing photos. You can change your username at any time.',
              style: body2Style(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              height: 46,
              width: double.infinity,
              child: ICFlatButton(
                text: 'Next',
                onPressed: () {
                  userRepo.nextOnSucess();
                  print('Finished');
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TappableText(
              text: 'Change username',
              onTap: () => {
                print('Change Username'),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeUsername(
                            profileInformation: data,
                          )),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
