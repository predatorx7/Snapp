import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';
import '../../../core/services/profile.dart';
import '../../../core/utils/namegen.dart';
import '../../components/buttons.dart';
import '../../../models/plain_models/profile.dart';
import '../../../core/utils/validators.dart';

class ChangeUsername extends StatefulWidget {
  final Profile profileInformation;
  ChangeUsername({Key key, @required this.profileInformation})
      : super(key: key);
  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  TextEditingController _usernameController;
  bool _isButtonDisabled = true, valid = true;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
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
    Profile profileInformation = widget.profileInformation;
    return Scaffold(
      key: _key,
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
                    : () async {
                        if (GenerateUsername().checkAvailability(
                                [_usernameController.text]) !=
                            null) {
                          profileInformation.username =
                              _usernameController.text;
                          print(profileInformation.username);
                          setState(() {
                            _isButtonDisabled = true;
                          });
                          await ProfileService()
                              .updateProfile(profileInformation);
                          _key.currentState.showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                  'Username changed to ${_usernameController.text}'),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          _key.currentState.showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Username ${_usernameController.text} is already taken by someone else'),
                            ),
                          );
                        }
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
