import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/src/core/utils/styles.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/ui/components/buttons.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController, _passwordController;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _isButtonDisabled = true;
  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
      body: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'English (India)',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 65,
                        child: Image(
                          image: AssetImage('assets/res_image/logo.png'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(
                          color: notBlack,
                          fontSize: 12,
                          height: 1.34,
                        ),
                        controller: _usernameController,
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            if (_isButtonDisabled)
                              setState(() => _isButtonDisabled = false);
                          } else if (!_isButtonDisabled) {
                            setState(() => _isButtonDisabled = true);
                          }
                        },
                        cursorWidth: 0.75,
                        cursorColor: Colors.grey,
                        decoration: outlineTextField(
                            hintText:
                                'Phone number. email address or username'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        style: TextStyle(
                          color: notBlack,
                          fontSize: 12,
                          height: 1.34,
                        ),
                        controller: _passwordController,
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              _usernameController.text.isNotEmpty) {
                            if (_isButtonDisabled)
                              setState(() => _isButtonDisabled = false);
                          } else if (!_isButtonDisabled) {
                            setState(() => _isButtonDisabled = true);
                          }
                        },
                        obscureText: true,
                        cursorWidth: 0.75,
                        cursorColor: Colors.grey,
                        decoration: outlineTextField(hintText: 'Password'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 46,
                        width: double.infinity,
                        child: ICFlatButton(
                          conditionForProcessIndicator:
                              user.status == Status.Authenticating,
                          text: 'Log In',
                          onPressed: _isButtonDisabled
                              ? null
                              : () async {
                                  if (await user.signIn(
                                      _usernameController.text,
                                      _passwordController.text,
                                      _key)) {
                                    print('Logging in');
                                  }
                                },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: new TextSpan(
                          style: new TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                              text: 'Forgotten your login details? ',
                            ),
                            new TextSpan(
                              text: 'Get help signing in',
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff262626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      user.openPage(page: 'CheckEmail');
                    },
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                            text: 'Don\'t have an account? ',
                          ),
                          new TextSpan(
                            text: 'Sign up.',
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff262626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
          Column(
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Instagram clone by Mushaheed',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ),
              Divider(
                height: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
