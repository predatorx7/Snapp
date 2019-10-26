import 'package:flutter/material.dart';
import 'package:instagram/commons/styles.dart';

class PickGender extends StatefulWidget {
  final String receivedGender;

  const PickGender({Key key, @required this.receivedGender}) : super(key: key);
  @override
  _PickGenderState createState() => _PickGenderState();
}

class _PickGenderState extends State<PickGender> {
  String selectedGender;
  String one = "Female",
      two = "Male",
      three = "Custom",
      four = "Prefer Not to Say";
  @override
  void initState() {
    selectedGender = widget.receivedGender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 35,
          icon: Icon(Icons.close),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Gender",
          style: actionTitle3Style(),
        ),
        actions: <Widget>[
          IconButton(
            color: Color(actionColor),
            icon: Icon(Icons.done),
            onPressed: () async {
              if (widget.receivedGender != selectedGender) {
                Navigator.pop(context, selectedGender);
              } else {
                Navigator.of(context);
              }
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          RadioListTile(
            value: one,
            groupValue: selectedGender,
                selected: selectedGender == one,
            onChanged: (ind) => setState(() => selectedGender = ind),
            activeColor: Color(actionColor),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(
              one,
              style: body3Style(),
            ),
          ),
          RadioListTile(
            value: two,
            groupValue: selectedGender,
                selected: selectedGender == two,
            onChanged: (ind) => setState(() => selectedGender = ind),
            activeColor: Color(actionColor),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(
              two,
              style: body3Style(),
            ),
          ),
          RadioListTile(
            value: three,
            groupValue: selectedGender,
                selected: selectedGender == three,
            onChanged: (ind) => setState(() => selectedGender = ind),
            activeColor: Color(actionColor),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(
              three,
              style: body3Style(),
            ),
          ),
          RadioListTile(
            value: four,
            groupValue: selectedGender,
                selected: selectedGender == four,
            onChanged: (ind) => setState(() => selectedGender = ind),
            activeColor: Color(actionColor),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(
              four,
              style: body3Style(),
            ),
          ),
        ],
      ),
    );
  }
}
