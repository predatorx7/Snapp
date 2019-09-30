import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/models/view_models/login_page.dart';
import '../../commons/styles.dart';
import '../../models/plain_models/auth.dart';
import '../components/buttons.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController, _passwordController;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  AuthNotifier user;
  LoginPageViewModel view;
  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  @override
  void dispose() {
    user.dispose();
    view.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AuthNotifier>(context);
    view = Provider.of<LoginPageViewModel>(context, listen: false);
    return Scaffold(
      key: _key,
      body: Container(
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
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
                      view.validateInput(
                          value: value, textController: _passwordController);
                    },
                    cursorWidth: 0.75,
                    cursorColor: Colors.grey,
                    decoration: outlineTextField(
                        hintText: 'Phone number. email address or username'),
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
                      view.validateInput(
                          value: value, textController: _usernameController);
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
                    child: Consumer<LoginPageViewModel>(
                      builder:
                          (BuildContext context, LoginPageViewModel _view, _) {
                        return ICFlatButton(
                          conditionForProcessIndicator:
                              user.status == Status.Authenticating,
                          text: 'Log In',
                          onPressed: _view.isButtonDisabled
                              ? null
                              : () async {
                                  if (await user.signIn(
                                      _usernameController.text,
                                      _passwordController.text,
                                      _key)) {
                                    print('[Success] Logging in');
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Signed in'),
                                      ),
                                    );
                                    // Navigator.pushReplacementNamed(
                                    //     context, HomeRoute);
                                  }
                                },
                        );
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
                  print('[Login Page] Detected Gesture');
                  Navigator.of(context).pushNamed(SignUpRoute);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Wrap(
          children: [
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
      ),
    );
  }
}
