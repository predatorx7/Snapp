import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController usernameController;
  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Widget testWidgetBlock(int number, {void Function() perform}) {
    return Column(
      children: <Widget>[
        Text('Text $number'),
        TextField(
          controller: usernameController,
        ),
        RaisedButton(
          onPressed: perform ??
              () {
                /// Use `ScopedModel.of<TestPageModel>(context);`
                print('No Tasks Specified');
              },
          child: Text('Start Test $number?'),
        ),
        Text('Results: '),
        ScopedModelDescendant<TestPageModel>(
          builder: (context, _, TestPageModel view) {
            try {
              return Text(view._result[number] ?? 'Waiting for result');
            } catch (e) {
              return Text('Waiting for result');
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: ScopedModel<TestPageModel>(
        model: TestPageModel(),
        child: ListView(
          children: <Widget>[
            testWidgetBlock(1),
          ],
        ),
      ),
    );
  }
}

class TestPageModel extends Model {
  List _result;

  get result => _result;

  setResult(result) {
    _result.add(result);
    notifyListeners();
  }
}
