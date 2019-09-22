import 'package:flutter/material.dart';
import 'package:instagram/src/core/utils/validators.dart';
import 'package:instagram/src/core/utils/styles.dart';
import 'package:instagram/src/models/plain_models/user_repo.dart';
import 'package:instagram/src/ui/components/buttons.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
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
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      key: _key,
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
                          setState(() {
                            _usernameController.text = '';
                          });
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
                        user.status == Status.CheckingEmail,
                    text: 'Next',
                    onPressed: _isButtonDisabled
                        ? null
                        : () async {
                            Validator3000 valValue = Validator3000();
                            print('I work');
                            var textIs =
                                valValue.isEmailValid(_usernameController.text);
                            if (textIs != null) {
                              setState(() {
                                _showError = true;
                              });
                            } else {
                              await user.doesEmailExist(
                                  email: _usernameController.text, key: _key);
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
