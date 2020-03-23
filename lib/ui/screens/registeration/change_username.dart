import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/models/view_models/change_username.dart';
import 'package:instagram/models/view_models/signup_page.dart';
import 'package:provider/provider.dart';
import '../../../core/services/profile.dart';
import '../../../core/utils/namegen.dart';
import '../../components/buttons.dart';
import '../../../repository/profile.dart';
import '../../../core/utils/validators.dart';

class ChangeUsername extends StatefulWidget {
  final bool authenticated;
  ChangeUsername({Key key, this.authenticated = false}) : super(key: key);
  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  TextEditingController _usernameController;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  FocusNode _focusPassword;
  SignUpViewModel _fromSignUp;
  bool updatedUsername = false;

  @override
  void initState() {
    _usernameController = new TextEditingController();
    _focusPassword = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _fromSignUp = Provider.of<SignUpViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _fromSignUp.dispose();
    _usernameController.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Profile profileUsername = widget.profileUsername;

    return Scaffold(
      key: _key,
      body: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28.0),
        child: ChangeNotifierProvider(
          create: (context) => ChangeUsernameViewModel(),
          child: Consumer<ChangeUsernameViewModel>(builder:
              (BuildContext context, ChangeUsernameViewModel _view, Widget _) {
            if (!updatedUsername) {
              if (!widget.authenticated) {
                _view.setUsername(_fromSignUp.username);
              }
              updatedUsername = true;
            }
            return Column(
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
                      _view.setValidity(false);
                      if (!_view.isButtonDisabled) _view.toggleButton(true);
                    } else if (!Validator3000().isIdValid(value)) {
                      _view.setValidity(false);
                      if (!_view.isButtonDisabled) {
                        _view.setErrorText('Username $value is invalid.');
                        _view.toggleButton(true);
                      }
                    } else {
                      if (_view.isButtonDisabled) {
                        _view.setErrorText(null);
                        _view.toggleButton(false);
                      }
                    }
                  },
                  cursorWidth: 0.75,
                  cursorColor: Colors.grey,
                  decoration: outlineTextField(
                    hintText: 'Username',
                    errorText: _view.errorText,
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
                        _view.status == ChangeUsernameStatus.Working,
                    text: 'Next',
                    onPressed: _view.isButtonDisabled
                        ? null
                        : () async {
                            // Checking Username availability
                            _view.setStatus(ChangeUsernameStatus.Working);
                            var futureString = await GenerateUsername()
                                .checkAvailability([_usernameController.text]);
                            if (futureString != null) {
                              // Username available
                              _view.setUsername(_usernameController.text);
                              print(_view.username);
                              _view.toggleButton(true);
                              if (widget.authenticated) {
                                print(
                                    '[Change Username Page] Authenticated user: Updating Username ${_view.username}');
                                await ProfileService().updateProfile(
                                    Profile(username: _view.username));
                                _key.currentState.showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        'Username updated to ${_usernameController.text}'),
                                  ),
                                );
                                _view.setStatus(ChangeUsernameStatus.Standby);
                              } else {
                                print(
                                    '[Change Username Page] Unauthenticated user: Changing Username');

                                _view.setStatus(ChangeUsernameStatus.Standby);
                              }
                              Navigator.pop(
                                  context, [true, _usernameController.text]);
                            } else {
                              _view.setStatus(ChangeUsernameStatus.Failed);
                              _key.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Username ${_usernameController.text} is already taken by someone else',
                                  ),
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
            );
          }),
        ),
      ),
    );
  }
}
