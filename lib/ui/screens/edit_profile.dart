import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/core/utils/namegen.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:instagram/models/view_models/edit_profile.dart';
import 'package:instagram/ui/components/dialog.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseDatabase db = FirebaseDatabase.instance;
  GlobalKey<ScaffoldState> _key;
  bool loaded = false;
  TextEditingController nameController,
      usernameController,
      bioController,
      emailController,
      genderController;
  InfoModel info;
  EditProfileModel view;
  @override
  void initState() {
    nameController = TextEditingController();
    usernameController = TextEditingController();
    bioController = TextEditingController();
    emailController = TextEditingController();
    genderController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    info = Provider.of<InfoModel>(context);
    view = Provider.of<EditProfileModel>(context);
    view.setInformation(info.info);
    if (!loaded) {
      nameController.text = view.information.fullName;
      usernameController.text = view.information.username;
      bioController.text = view.information.bio;
      emailController.text = view.information.email;
      genderController.text = view.information.gender;
      loaded = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 35,
          icon: Icon(Icons.close),
          onPressed: () async {
            if (view.information.toJson() != info.info.toJson()) {
              bool value = await basicDialog(
                  context: context,
                  title: "Unsaved changes",
                  details:
                      "You have unsaved changes. Are\nyou sure you want to cancel?");
              if (value) {
                Navigator.maybePop(context);
              }
            }
          },
        ),
        title: Text(
          "Edit Profile",
          style: actionTitle2Style(),
        ),
        actions: <Widget>[
          IconButton(
            color: Color(actionColor),
            icon: Icon(Icons.done),
            onPressed: () async {
              Profile information = info.info;
              information.fullName = nameController.text;
              information.username = usernameController.text;
              if (bioController.text.isNotEmpty)
                information.bio = bioController.text;
              information.email = emailController.text;
              information.gender = genderController.text;
              view.setInformation(information);
              var xx = await ProfileService().updateProfile(view.information);
              if (xx) {
                info.setInfo(view.information);
                Navigator.maybePop(context);
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Something weird happened"),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: ICProfileAvatar(
              database: db,
              profileOf: info.info.uid,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () async {
              bool changePic = false;
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "Change Profile Photo",
                            style: actionTitle3Style(),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            changePic = true;
                            await Navigator.maybePop(context);
                          },
                          title: Text("New Profile Photo"),
                        ),
                        ListTile(
                          onTap: () {
                            print("");
                          },
                          title: Text("Remove profile photo"),
                        ),
                      ],
                    ),
                  );
                },
              );
              if (changePic) {
                Navigator.pushNamed(
                  context,
                  ChangeProfilePicRoute,
                );
              }
            },
            child: Center(
              child: Text(
                "Change Profile Photo",
                style: actionTap2Style(),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: editPageInputBorder('Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                suffixIcon:
                    view.isBusy ? CircularProgressIndicator() : SizedBox(),
                errorText:
                    view.usernameAvailable ? "Username not available" : null,
                labelText: "Username",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) async {
                view.toggleBusy(true);
                bool isAvailable =
                    await GenerateUsername().isUsernameAvailable(value);
                view.setUsernameAvailable(isAvailable);
                view.toggleBusy(false);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: bioController,
              decoration: editPageInputBorder("Bio"),
            ),
          ),
          Divider(),
          Divider(),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Profile information",
              style: actionTitleStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.bold),
              controller: emailController,
              decoration: InputDecoration(
                labelText: "E-mail Address",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Object reply;
              // Get gender from page
            },
            child: AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: genderController,
                  decoration: editPageInputBorder("Gender"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
