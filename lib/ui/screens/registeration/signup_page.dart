import 'package:flutter/material.dart';
import '../../../commons/routing_constants.dart';
import '../../../core/services/registration_service.dart';
import '../../../core/services/profile.dart';
import '../../../models/view_models/signup_page.dart';
import '../../components/buttons.dart';
import 'package:provider/provider.dart';
import '../../../models/plain_models/auth.dart';
import '../../../commons/styles.dart';
import '../../../core/utils/validators.dart';
import 'change_username.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SignStep1();
  }
}

class _SignStep1 extends StatefulWidget {
  // GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  __SignStep1State createState() => __SignStep1State();
}

class __SignStep1State extends State<_SignStep1> {
  TextEditingController _usernameController;

  // bool _isButtonDisabled = true, _isTapped = false, _showError = false;

  FocusNode _focusEmail;

  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController();
    _focusEmail = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _focusEmail.dispose();
    super.dispose();
  }

  Widget _icon() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          width: 154,
          height: 154,
          padding: const EdgeInsets.all(2.0), // borde width
          decoration: BoxDecoration(
            color: notBlack, // border color
            shape: BoxShape.circle,
          ),
        ),
        Container(
          child: CircleAvatar(
            child: Icon(
              Icons.person_outline,
              size: 100,
              color: notBlack,
            ),
            backgroundColor: Colors.transparent,
          ),
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(2.0), // borde width
          decoration: BoxDecoration(
            color: Colors.white, // border color
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _emailButton(BuildContext context) {
    final view = Provider.of<SignUpViewModel>(context);
    return GestureDetector(
      onTap: () {
        if (!view.isTapped) {
          view.setTap(true);
          FocusScope.of(context).requestFocus(_focusEmail);
          print('IsTapped now True');
        } else {
          view.setTap(false);
          print('IsTapped now False');
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'EMAIL ADDRESS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: view.isTapped ? Colors.black : Colors.grey,
            ),
          ),
          SizedBox(
            height: view.isTapped ? 14.5 : 15,
          ),
          Container(
            height: view.isTapped ? 1.5 : 1,
            width: 200,
            margin: EdgeInsetsDirectional.only(start: 0, end: 0),
            decoration: BoxDecoration(
              color: view.isTapped ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final view = Provider.of<SignUpViewModel>(context);
    return Scaffold(
      // key: _key,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _icon(),
            SizedBox(
              height: 20,
            ),
            _emailButton(context),
            SizedBox(
              height: 15,
            ),
            TextField(
              focusNode: _focusEmail,
              onTap: () {
                if (view.isTapped) view.setTap(true);
              },
              style: TextStyle(
                color: notBlack,
                fontSize: 12,
                height: 1.34,
              ),
              controller: _usernameController,
              onChanged: (value) {
                if (view.showError) view.setError(false);
                if (value.isNotEmpty) {
                  if (view.isButtonDisabled) view.setButton(false);
                } else if (!view.isButtonDisabled) {
                  view.setButton(true);
                }
              },
              cursorWidth: 0.75,
              cursorColor: Colors.grey,
              decoration: outlineTextField(
                hintText: 'Email address',
                errorText: view.showError
                    ? 'Please enter a valid email address'
                    : null,
                suffixIcon: Visibility(
                  visible: view.showError,
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          _usernameController.text = '';
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 46,
              width: double.infinity,
              child: ICFlatButton(
                conditionForProcessIndicator:
                    view.signUpStatus == SignUpStatus.Running,
                text: 'Next',
                onPressed: view.isButtonDisabled
                    ? null
                    : () async {
                        bool emailExists;
                        Validator3000 valValue = Validator3000();
                        print('I work');
                        var textIs =
                            valValue.isEmailValid(_usernameController.text);
                        if (textIs != null) {
                          view.setError(true);
                        } else {
                          emailExists = await RegisterService().doesEmailExist(
                              email: _usernameController.text,
                              context: context);
                          if (!emailExists) {
                            Navigator.pushNamed(context, SignUpStep2Route,
                                arguments: _usernameController.text);
                          }
                        }
                      },
              ),
            ),
          ],
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

class SignStep2 extends StatefulWidget {
  final String email;

  const SignStep2({Key key, this.email}) : super(key: key);
  @override
  _SignStep2State createState() => _SignStep2State();
}

class _SignStep2State extends State<SignStep2> {
  // TODO Here
  TextEditingController _usernameController, _passwordController;
  // bool _isButtonDisabled = true, _isTapped = false, _showError = false;
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
    final _signUp = Provider.of<SignUp2ViewModel>(context);
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
                if (!_signUp.isTapped) _signUp.setTap(true);
              },
              style: TextStyle(
                color: notBlack,
                fontSize: 12,
                height: 1.34,
              ),
              controller: _usernameController,
              onChanged: (value) {
                if (value.isNotEmpty && _passwordController.text.isNotEmpty) {
                  if (_signUp.isButtonDisabled) _signUp.setButton(false);
                } else if (!_signUp.isButtonDisabled) {
                  _signUp.setButton(true);
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
                if (!_signUp.isTapped) _signUp.setTap(true);
              },
              style: TextStyle(
                color: notBlack,
                fontSize: 12,
                height: 1.34,
              ),
              controller: _passwordController,
              onChanged: (value) {
                if (_signUp.showError) _signUp.setError(false);
                _signUp.validateInput(
                    value: value, textController: _usernameController);
              },
              onSubmitted: (text) {
                if (text.length < 7) _signUp.setError(true);
              },
              cursorWidth: 0.75,
              cursorColor: Colors.grey,
              obscureText: true,
              decoration: outlineTextField(
                hintText: 'Password',
                errorText: _signUp.showError
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
                conditionForProcessIndicator:
                    _signUp.signUpStatus == SignUp2Status.Running,
                text: 'Continue',
                onPressed: _signUp.isButtonDisabled
                    ? null
                    : () async {
                        Validator3000 valValue = Validator3000();
                        print('I work');
                        var validity = true;
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
                          _signUp.setError(true);
                          validity = false;
                        }
                        if (validity) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    builder: (context) => SignUp3ViewModel(),
                                  ),
                                  ChangeNotifierProvider.value(
                                    value: AuthNotifier.instance(),
                                  ),
                                ],
                                child: new SignStep3(
                                  email: widget.email,
                                  fullName: _usernameController.text,
                                  password: _passwordController.text,
                                ),
                              ),
                            ),
                          );
                        }
                      },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              bottom: 15,
            ),
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
          ),
        ],
      ),
    );
  }
}

class SignStep3 extends StatefulWidget {
  final String email, fullName, password;
  SignStep3({this.email, this.fullName, this.password});
  @override
  _SignStep3State createState() => _SignStep3State();
}

class _SignStep3State extends State<SignStep3> {
  String userId, userEmail;
  SignUp3ViewModel _view;
  ProfileService profileAdapter = ProfileService();
  AuthNotifier userAuth;
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userAuth = Provider.of<AuthNotifier>(context);
    _view = Provider.of<SignUp3ViewModel>(context);
    if (!_view.hasUsername) {
      _view.provideUsername(widget.email, widget.fullName);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _view.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              _view.username ?? 'wait',
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
                onPressed: (_view.username == null)
                    ? null
                    : () async {
                        print('[Sign Up Page 3] Username: ${_view.username}');
                        bool result = await userAuth.signUp(
                            widget.email,
                            widget.fullName,
                            widget.password,
                            context,
                            _view.username);
                        result
                            ? print('user created: ${userAuth.user}')
                            : print('Something unexpected happened');
                        print('Finished');
                      },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TappableText(
              text: 'Change username',
              onTap: (_view.username == null)
                  ? null
                  : () async {
                      print('[SignUp Page] Change Username');
                      Object navResult = await Navigator.pushNamed(
                          context, ChangeUsernameRoute);
                      List<dynamic> result = navResult;
                      if (result[0]) {
                        _view.setUsername(result[1]);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
