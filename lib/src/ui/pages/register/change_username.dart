import 'package:flutter/material.dart';
import 'package:instagram/src/core/utils/validators.dart';
import 'package:instagram/src/core/utils/styles.dart';
import 'package:instagram/src/ui/components/buttons.dart';

class ChangeUsername extends StatefulWidget {
  final String userId;
  ChangeUsername({this.userId = 'smushaheed'});
  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  TextEditingController _usernameController;
  bool _isButtonDisabled = true, valid = true;
  String _errorText;
  FocusNode _focusPassword;
  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController();
    _focusPassword = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

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
              'CHANGE USERNAME',
              style: headStyle(),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Choose a username for your account. You can always change it later.',
              style: body2Style(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 35,
            ),
            TextField(
              autofocus: true,
              style: TextStyle(
                color: notBlack,
                fontSize: 12,
                height: 1.34,
              ),
              controller: _usernameController,
              onChanged: (value) {
                if (value.length <= 6) {
                  valid = false;
                  if (!_isButtonDisabled)
                    setState(() => _isButtonDisabled = true);
                } else if (!Validator3000().isIdValid(value)) {
                  valid = false;
                  if (!_isButtonDisabled)
                    setState(() => {
                          _errorText = 'Username $value is invalid.',
                          _isButtonDisabled = true
                        });
                } else {
                  if (_isButtonDisabled)
                    setState(
                        () => {_errorText = null, _isButtonDisabled = false});
                }
              },
              cursorWidth: 0.75,
              cursorColor: Colors.grey,
              decoration: outlineTextField(
                hintText: 'Username',
                errorText: _errorText,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 46,
              width: double.infinity,
              child: ICFlatButton(
                text: 'Next',
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        print('Finished');
                      },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Username can\'t start or end with a period & can only contain alphabets, numbers, periods or underscores',
              style: body2Style(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
