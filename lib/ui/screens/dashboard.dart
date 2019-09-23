// View with DATA after Authenticated Login
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/plain_models/auth.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  final FirebaseUser user;

  const Dashboard({Key key, this.user}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Info"),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Email: ${widget.user.email}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Row(children: <Widget>[Text("User ID: ${widget.user.uid}", style: TextStyle(),),],),
          ButtonBar(
            children: <Widget>[
              OutlineButton(
                borderSide: BorderSide(color: Colors.red),
                highlightedBorderColor: Colors.redAccent,
                textColor: Colors.red,
                child: Text("SIGN OUT"),
                onPressed: () => Provider.of<AuthNotifier>(context).signOut(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
