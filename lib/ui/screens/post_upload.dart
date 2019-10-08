import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/plain_models/information.dart';
import '../../core/services/posts.dart';
import '../components/buttons.dart';

class PostUploadPage extends StatefulWidget {
  const PostUploadPage({Key key}) : super(key: key);
  @override
  _PostUploadPageState createState() => _PostUploadPageState();
}

class _PostUploadPageState extends State<PostUploadPage> {
  File _image;
  int _buttonIndex = 0;

  initState() {
    super.initState();
  }

  dispose() {
    if (_image != null) _image.delete();
    super.dispose();
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source, imageQuality: 60);

    setState(() {
      _image = image;
    });
  }

  setIndex(int index) {
    setState(() {
      _buttonIndex = index;
    });
  }

  Widget isUsing(int ofIndex) {
    return Container(
      height: ofIndex == _buttonIndex ? 1.5 : 1,
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(start: 0, end: 0),
      decoration: BoxDecoration(
        color: ofIndex == _buttonIndex ? Colors.black : Colors.grey,
      ),
    );
  }

  Widget imageWillbe() {
    if (_image == null) {
      return Center(
        child: Text(
          'No media selected',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return Container(
      color: Colors.grey[200],
      child: _image != null
          ? Image.file(
              _image,
              fit: BoxFit.fitWidth,
            )
          : SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 55,
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Upload',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  TappableText(
                    onTap: _image != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadMedia(
                                  imageFile: _image,
                                ),
                              ),
                            );
                          }
                        : null,
                    text: 'Next',
                    textSize: 16,
                  ),
                ],
              ),
            ),
            Expanded(
              child: imageWillbe(),
            ),
          ],
        ),
        bottom: true,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.black,
              blurRadius: 8,
              spreadRadius: -6,
            ),
          ],
        ),
        child: Container(
          height: 50,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: InkResponse(
                  onTap: () => {
                    setIndex(0),
                    getImage(ImageSource.gallery),
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[SizedBox(), Text('Gallery'), isUsing(0)],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => {
                    setIndex(1),
                    getImage(ImageSource.camera),
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[SizedBox(), Text('Photo'), isUsing(1)],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => {setIndex(2), print('Video not supported')},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[SizedBox(), Text('Video'), isUsing(2)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadMedia extends StatefulWidget {
  final File imageFile;

  const UploadMedia({Key key, this.imageFile}) : super(key: key);
  @override
  _UploadMediaState createState() => _UploadMediaState();
}

class _UploadMediaState extends State<UploadMedia> {
  TextEditingController captionController;
  bool _isLoading = false;
  FocusNode captionFocus;
  @override
  void initState() {
    captionFocus = FocusNode();
    captionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    captionFocus.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _info = Provider.of<InfoModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          Center(
            child: TappableText(
              onTap: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      captionFocus.unfocus();
                      await uploadFile(widget.imageFile, _info.info.uid,
                          captionController.text, _info.info.username);
                      // Upload and await here
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
              text: 'Share',
              textSize: 16,
            ),
          ),
        ],
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: _isLoading,
            child: LinearProgressIndicator(),
          ),
          Container(
            padding: EdgeInsets.all(15),
            height: 300,
            // width: 300,
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              focusNode: captionFocus,
              minLines: 1,
              maxLines: 20,
              controller: captionController,
              textInputAction: TextInputAction.newline,
              maxLength: 150,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: CircleAvatar(
                  child: Icon(Icons.person_outline),
                ),
                hintText: 'Write a caption...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future uploadFile(
    File _image, String uid, String caption, String username) async {
  int time = DateTime.now().millisecondsSinceEpoch;
  StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child('posts/$uid/${DateTime.now().millisecondsSinceEpoch}');
  StorageUploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.onComplete;
  print('File Uploaded');
  storageReference.getDownloadURL().then(
    (fileURL) {
      PostService().createPost(fileURL, uid, caption, time, username);
    },
  );
}
