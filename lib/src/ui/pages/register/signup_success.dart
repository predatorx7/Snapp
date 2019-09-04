import 'package:flutter/material.dart';
import 'package:instagram/src/core/utils/styles.dart';
import 'package:instagram/src/ui/pages/register/change_username.dart';
import 'package:instagram/src/ui/components/buttons.dart';

class SignUpSuccess extends StatefulWidget {
  /// CHECK & Recieve USERID VIA PROVIDER
  final String userId;
  SignUpSuccess({this.userId = 'smushaheed'});
  @override
  _SignUpSuccessState createState() => _SignUpSuccessState();
}

class _SignUpSuccessState extends State<SignUpSuccess> {
  @override
  Widget build(BuildContext context) {
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
            Text(
              widget.userId,
              style: bodyStyle(),
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
                  MaterialPageRoute(builder: (context) => ChangeUsername()),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
