import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/core/services/registration_service.dart';
import '../../../core/services/profile.dart';
import '../../../models/plain_models/profile.dart';
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

  bool _isButtonDisabled = true, _isTapped = false, _showError = false;

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
    return GestureDetector(
      onTap: () {
        if (!_isTapped) {
          setState(() => {
                _isTapped = true,
                FocusScope.of(context).requestFocus(_focusEmail),
              });
          print('IsTapped now True');
        } else {
          setState(() => {
                _isTapped = false,
              });
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
              color: _isTapped ? Colors.black : Colors.grey,
            ),
          ),
          SizedBox(
            height: _isTapped ? 14.5 : 15,
          ),
          Container(
            height: _isTapped ? 1.5 : 1,
            width: 200,
            margin: EdgeInsetsDirectional.only(start: 0, end: 0),
            decoration: BoxDecoration(
              color: _isTapped ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthNotifier>(context);
    final signUp = Provider.of<SignUpModel>(context);
    return Scaffold(
      // key: _key,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
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
                    if (_showError)
                      setState(() {
                        _showError = false;
                      });
                    if (value.isNotEmpty) {
                      if (_isButtonDisabled)
                        setState(() => _isButtonDisabled = false);
                    } else if (!_isButtonDisabled) {
                      setState(() => _isButtonDisabled = true);
                    }
                  },
                  cursorWidth: 0.75,
                  cursorColor: Colors.grey,
                  decoration: outlineTextField(
                    hintText: 'Email address',
                    errorText: _showError
                        ? 'Please enter a valid email address'
                        : null,
                    suffixIcon: Visibility(
                      visible: _showError,
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
                        signUp.signUpStatus == SignUpStatus.Running,
                    text: 'Next',
                    onPressed: _isButtonDisabled
                        ? null
                        : () async {
                            bool emailExists;
                            Validator3000 valValue = Validator3000();
                            print('I work');
                            var textIs =
                                valValue.isEmailValid(_usernameController.text);
                            if (textIs != null) {
                              setState(() {
                                _showError = true;
                              });
                            } else {
                              emailExists = await RegisterService()
                                  .doesEmailExist(
                                      email: _usernameController.text,
                                      context: context);
                              if (!emailExists) {
                                Navigator.pushNamed(context, SignUpStep2Route);
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
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
          )
        ],
      ),
    );
  }
}

class SignStep2 extends StatefulWidget {
  @override
  _SignStep2State createState() => _SignStep2State();
}

class _SignStep2State extends State<SignStep2> {
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
    final _signUp = Provider.of<SignUpModel>(context);
    final _auth = Provider.of<AuthNotifier>(context);
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
                conditionForProcessIndicator:
                    _signUp.signUpStatus == SignUpStatus.Running,
                text: 'Continue',
                onPressed: _isButtonDisabled
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
                          setState(() {
                            _showError = true;
                          });
                          validity = false;
                        }
                        if (validity) {
                          bool result = await RegisterService().signUp(
                              _signUp.email,
                              _usernameController.text,
                              _passwordController.text,
                              context,
                              _auth.user);
                          result
                              ? print('user created')
                              : print('Something unexpected happened');
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

class SignStep3 extends StatefulWidget {
  SignStep3();
  @override
  _SignStep3State createState() => _SignStep3State();
}

class _SignStep3State extends State<SignStep3> {
  String userId, userEmail;
  Profile data;
  ProfileService profileAdapter = ProfileService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<AuthNotifier>(context);
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
                        data = Profile.fromMap(snapshot.data);
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
                  // userRepo.nextOnSucess();
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
                    ),
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
