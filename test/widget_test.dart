///This is a basic Flutter widget test.
///
///To perform an interaction with a widget in your test, use the WidgetTester
///utility that Flutter provides. For example, you can send tap and scroll
///gestures. You can also use WidgetTester to find child widgets in the widget
///tree, read text, and verify that the values of widget properties are correct.
///
///```dart
/////import files to test and their dependencies
///
///void main() {
///
///  setUp(functionbodies);
///
///  setUpAll(functionbodies);
///
///  group(description, () {
///    test(description, () {
///
///      expect(actual, matcher);
///

///    });
///  });
///
///  //Mock Object Creation
///  //Expected widget within created widgets
///
///  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
///
///  //Build our app and trigger a frame.
///
///  await tester.pumpWidget(MyApp());
///
///  //Gets the created widgets
///
///  //Calling Method to check if all results are created as expected.
///
///  });
///
///  //Method to check if all results are created as expected.
///
///}
///```

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:instagram/main.dart' as prefix1;

void main() {
  //setUp(EntryState().enableSignUpButton());
  testWidgets('smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget((prefix1.Root()));
    // Iterable<Element> ele = tester.allElements;

    print(tester.allWidgets);
    await tester.pump();
    // print(ele);
    // await tester.tap(find.byType(RaisedButton));
    // await tester.pump();
    // expect(find.text('New text'), findsOneWidget);
    // await tester.enterText(find.byType(TextField), 'I am a text');
    // await tester.pump();
    // expect(find.text('I am a test'), findsOneWidget);
    // await tester.tap(find.byType(RaisedButton));
    // await tester.pump();
    // expect(find.text('New text'), findsOneWidget);
  });
  /*
  testWidgets('smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget((prefix1.EntryStateless()));
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.text('New text'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'I am a text');
    await tester.pump();
    expect(find.text('I am a test'), findsOneWidget);
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.text('New text'), findsOneWidget);
  });
  */
  group("Functional checks", () {
    //EntryState().enableSignInButton();

    test('To test Validations', () {
      //declare variables
      //expect(signInValidationTest(), 'Enter email');
      //expect(textEditingControllerTest(), 'key');
      //expect(signUpValidationTest(), 'Enter Password');
    });
  });
}

signInValidationTest() {
  //EntryState e;
  //e.signInEmailID.value = 'smushaheed.com';
  //print(e.signInEmailID.value);
  //e.signInEmailID.text = 'hey';
  //return Validator3000().isEmailValid(email: e.signInEmailID.text.toString());
}

textEditingControllerTest() {
  //TextEditingController texting;
  //texting.text = 'key';
  //return texting.text;
  //e.signInEmailID.text = 'hey';
  //return Validator3000().isEmailValid(email: e.signInEmailID.text.toString());
}

signUpValidationTest() {
  //EntryState e;
  //e.signUpPassword.text = '';
  //return Validator3000().isPasswordValid(password: e.signUpPassword.text);
}

// RaisedButton(
//   onPressed: () {
//     feedModel.messageCounter(feedModel.getMessageCount() + 1);
//   },
//   child: Text('Increase message'),
// ),
