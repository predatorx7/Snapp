import 'package:flutter/material.dart';
import 'package:instagram/src/pages/widgets/buttons.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _addCommentController;
  bool _isButtonDisabled = true;
  @override
  void initState() {
    super.initState();
    _addCommentController = new TextEditingController();
  }

  @override
  void dispose() {
    _addCommentController.dispose();
    super.dispose();
  }

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
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                print('Goto Inbox');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/res_icons/directOutline.png'),
                  fit: BoxFit.contain,
                  width: 25.0,
                  height: 25.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Padding(
                ///Show if Caption Exist
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          RichText(
                            // maxLines: 16,
                            textAlign: TextAlign.left,
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                  text: 'User_name ',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                new TextSpan(
                                  text:
                                      'Abc def ghi jkh lmn opq rst uvw xyz abc def ghi jkl mno',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              // TODO: Implement Builder to get 2D Comments
              ListView(
                shrinkWrap: true,
              )
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
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
                        controller: _addCommentController,
                        onChanged: (value) {
                          value.isEmpty
                              ? setState(() => _isButtonDisabled = true)
                              : setState(() => _isButtonDisabled = false);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TappableText(
                        text: 'Post',
                        // width: 68,
                        textSize: 14,
                        transparency: '0x55',
                        fontWeight: FontWeight.normal,
                        onTap: _isButtonDisabled
                            ? null
                            : () {
                                print('Posting');
                              },
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
