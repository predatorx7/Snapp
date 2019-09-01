import 'package:flutter/material.dart';
import 'package:instagram/src/pages/widgets/buttons.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text('Comments'),
        actions: <Widget>[
          Container(
            color: Colors.transparent,
            child: Ink.image(
              image: AssetImage('assets/icon/ic_inbox.png'),
              fit: BoxFit.contain,
              width: 40.0,
              height: 40.0,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  print('Goto Inbox');
                },
                child: null,
              ),
            ),
          )
        ],
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          Column(
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ICFlatButton(
                      text: 'Post',
                    ),
                  ),
                ],
              ),
              Divider(
                height: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
