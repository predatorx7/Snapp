import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/models/plain_models/info.dart';
import 'package:instagram/ui/components/buttons.dart';
import 'package:instagram/ui/components/process_indicator.dart';
import 'package:provider/provider.dart';

class ProfilePicEditPage extends StatefulWidget {
  const ProfilePicEditPage({Key key}) : super(key: key);
  @override
  _ProfilePicEditPageState createState() => _ProfilePicEditPageState();
}

class _ProfilePicEditPageState extends State<ProfilePicEditPage> {
  File _image;
  int _buttonIndex = 0;
  InfoModel info;
  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    info = Provider.of<InfoModel>(context);
    super.didChangeDependencies();
  }

  @override
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

  Widget imageWillBe() {
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
          : Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  accentColor: Colors.grey[300],
                  primaryColor: Colors.grey,
                ),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: new CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
    );
  }

  Future<bool> setProfile(BuildContext context) async {
    try {
      // Set Image
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('profiles/${info.info.uid}/profile_picture');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then(
        (fileURL) async {
          info.info.profileImage = fileURL;
          await ProfileService().updateProfile(info.info);
        },
      );
      return true;
    } catch (e) {
      print("Could\'nt set profile pciture");
      return false;
    }
  }

  Future<bool> mockFuture(BuildContext context) async {
    try {
      // Set Image
      await Future.delayed(
        Duration(seconds: 4),
      );
      return false;
    } catch (e) {
      print("Could\'nt set profile pciture");
      return false;
    }
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
                    ),
                  ),
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
                        ? () async {
                            bool value;
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                setProfile(context).then((answer) {
                                  value = answer;
                                  Navigator.maybePop(context);
                                });
                                // mockFuture(context).then((answer) {
                                //   value = answer;
                                //   Navigator.maybePop(context);
                                // });
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          'Loading',
                                          style: body5Style(),
                                        ),
                                        ICProcessIndicator(
                                          size: 32,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            if (!value) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Could\'nt set profile picture"),
                                ),
                              );
                            } else {
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName('/'),
                              );
                            }
                          }
                        : null,
                    text: 'Set',
                    textSize: 16,
                  ),
                ],
              ),
            ),
            Expanded(
              child: imageWillBe(),
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
            ],
          ),
        ),
      ),
    );
  }
}
