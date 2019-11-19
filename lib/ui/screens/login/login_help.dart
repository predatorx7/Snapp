import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/utils/check.dart';
import 'package:instagram/models/view_models/loginhelp.dart';
import 'package:instagram/ui/components/buttons.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginHelpPage extends StatefulWidget {
  @override
  _LoginHelpPageState createState() => _LoginHelpPageState();
}

class _LoginHelpPageState extends State<LoginHelpPage> {
  FocusNode _focusEmail;
  TextEditingController _fieldController;
  @override
  void initState() {
    super.initState();
    _fieldController = new TextEditingController();
    _focusEmail = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _fieldController.dispose();
    _focusEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginHelpModel>(
      model: LoginHelpModel(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Login Help',
            style: actionTitle5Style(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                ),
                child: Text(
                  'Find your account',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Enter your Instagram clone username or email address linked to your account.',
                  style: body4Style(),
                  textAlign: TextAlign.center,
                ),
              ),
              ScopedModelDescendant<LoginHelpModel>(
                builder: (context, child, view) {
                  return TextField(
                    focusNode: _focusEmail,
                    onTap: () {
                      if (!view.isTapped) view.setTap(true);
                    },
                    style: TextStyle(
                      color: notBlack,
                      fontSize: 12,
                      height: 1.34,
                    ),
                    controller: _fieldController,
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
                      errorText: view.showError ? 'No users found' : null,
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
                                _fieldController.text = '';
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              ScopedModelDescendant<LoginHelpModel>(
                  builder: (context, child, view) {
                return Container(
                  height: 46,
                  width: double.infinity,
                  child: Builder(
                    builder: (builtContext) {
                      return ICFlatButton(
                        conditionForProcessIndicator:
                            view.signUpStatus == Status.Running,
                        text: 'Next',
                        onPressed: view.isButtonDisabled
                            ? null
                            : () async {
                                view.setStatus(Status.Running);
                                String found = await doesIdExists(
                                  text: _fieldController.text,
                                );
                                if(found == null){
                                  view.setError(true);
                                  view.setStatus(Status.Failed);
                                }else {
                                  view.setStatus(Status.Success);
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                    email: found,
                                  );
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // Call
                                      Future.delayed(
                                        Duration(seconds: 5),
                                        () => Navigator.pop(context),
                                      );
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 30,
                                                bottom: 10,
                                              ),
                                              child: Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                                size: 100,
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                  'Code Sent',
                                                  style: actionTitleStyle(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                  "We've sent a login code to ${_fieldController.text} to get you back into your account.",
                                                  style: body4Style(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 20),
                                                    child: new Text(
                                                      'OK',
                                                      style: actionTapStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  Navigator.pop(context);
                                }
                              },
                      );
                    },
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
