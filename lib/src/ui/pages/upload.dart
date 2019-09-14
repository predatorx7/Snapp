import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/src/models/plain_models/profile.dart';
import 'package:instagram/src/ui/components/buttons.dart';
import 'package:provider/provider.dart';

import '../../core/services/post_adapter.dart';
import '../../models/plain_models/user_repo.dart';
import 'instagram.dart';

class UploadPage extends StatefulWidget {
  final Profile profileData;
  const UploadPage({Key key, this.profileData}) : super(key: key);
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
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
    var image = await ImagePicker.pickImage(source: source);

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
                                      )),
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
  @override
  void initState() {
    captionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          TappableText(
            onTap: () async {
              await uploadFile(
                  widget.imageFile, userRepo.user, captionController.text);
              // Upload and await here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Instagram(),
                ),
              );
            },
            text: 'Share',
            textSize: 16,
          ),
        ],
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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

Future uploadFile(File _image, FirebaseUser user, String caption) async {
  StorageReference storageReference =
      FirebaseStorage.instance.ref().child('profiles/${user.email}/posts');
  StorageUploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.onComplete;
  print('File Uploaded');
  storageReference.getDownloadURL().then((fileURL) {
    PostAdapter().createPost(fileURL, user, caption);
  });
}
