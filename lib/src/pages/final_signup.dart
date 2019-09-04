import 'package:flutter/material.dart';
import 'package:instagram/src/core/validators.dart';
import 'package:instagram/src/core/values.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/pages/widgets/buttons.dart';
import 'package:provider/provider.dart';

class FinalSignUpPage extends StatefulWidget {
  final String emailId;
  FinalSignUpPage({this.emailId = 'smushaheed@test.com'});
  @override
  _FinalSignUpPageState createState() => _FinalSignUpPageState();
}

class _FinalSignUpPageState extends State<FinalSignUpPage> {
  TextEditingController _usernameController, _passwordController;
  bool _isButtonDisabled = true, _isTapped = false, _showError = false;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  FocusNode _focusPassword;
  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController();
    _passwordController = new TextEditingController();
    _focusPassword = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 15),
              child: Text(
                'NAME AND PASSWORD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            TextField(
              autofocus: true,
              onTap: () {
                !_isTapped
                    ? setState(() {
                        _isTapped = true;
                      })
                    : null;
              },
              style: TextStyle(
                color: notBlack,
                fontSize: 12,
                height: 1.34,
              ),
              controller: _usernameController,
              onChanged: (value) {
                if (value.isNotEmpty && _passwordController.text.isNotEmpty) {
                  if (_isButtonDisabled)
                    setState(() => _isButtonDisabled = false);
                } else if (!_isButtonDisabled) {
                  setState(() => _isButtonDisabled = true);
                }
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_focusPassword);
              },
              cursorWidth: 0.75,
              cursorColor: Colors.grey,
              decoration: outlineTextField(
                hintText: 'Full name',
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              focusNode: _focusPassword,
              onTap: () {
                !_isTapped
                    ? setState(() {
                        _isTapped = true;
                      })
                    : null;
              },
              style: TextStyle(
                color: notBlack,
                fontSize: 12,
                height: 1.34,
              ),
              controller: _passwordController,
              onChanged: (value) {
                if (_showError) {
                  setState(() {
                    _showError = false;
                  });
                }
                if (value.isNotEmpty && _usernameController.text.isNotEmpty) {
                  if (_isButtonDisabled)
                    setState(() => _isButtonDisabled = false);
                } else if (!_isButtonDisabled) {
                  setState(() => _isButtonDisabled = true);
                }
              },
              onSubmitted: (text) {
                if (text.length < 7)
                  setState(() {
                    _showError = true;
                  });
              },
              cursorWidth: 0.75,
              cursorColor: Colors.grey,
              obscureText: true,
              decoration: outlineTextField(
                hintText: 'Password',
                errorText: _showError
                    ? 'Password must be at least 6 characters long'
                    : null,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 46,
              width: double.infinity,
              child: ICFlatButton(
                conditionForProcessIndicator: user.status == Status.Registering,
                text: 'Continue',
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        Validator3000 valValue = Validator3000();
                        print('I work');
                        var validity = true;

                        /// TODO: STOP REGISTER ON INVALID NAME
                        if (valValue.isNameValid(_usernameController.text) !=
                            null) {
                          _key.currentState.showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                'Invalid name',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                          validity = false;
                        }

                        if (_passwordController.text.length < 7) {
                          setState(() {
                            _showError = true;
                          });
                          validity = false;
                        }
                        if (validity) {
                          user.signUp(
                              user.email, _passwordController.text, _key);
                        }
                      },
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.info_outline,
                    color: Colors.red[200],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Please check your mail for verification email after completing the registration process.',
                    style: TextStyle(color: Colors.red[200]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
