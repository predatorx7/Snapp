import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/commons/routing_constants.dart';
import 'package:instagram/commons/styles.dart';
import 'package:instagram/core/services/profile.dart';
import 'package:instagram/core/utils/namegen.dart';
import 'package:instagram/models/plain_models/info.dart';
import 'package:instagram/repository/profile.dart';
import 'package:instagram/models/view_models/edit_profile.dart';
import 'package:instagram/ui/components/process_indicator.dart';
import 'package:instagram/ui/components/profile_avatar.dart';
import 'package:instagram/ui/screens/pick_gender.dart';
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
    if (!loaded) {
      info = Provider.of<InfoModel>(context);
      view = Provider.of<EditProfileModel>(context);
      nameController.text = info.info.fullName;
      usernameController.text = info.info.username;
      if (info.info.bio.isNotEmpty) bioController.text = info.info.bio;
      emailController.text = info.info.email;
      genderController.text = info.info.gender;
      loaded = true;
    }
    super.didChangeDependencies();
  }

  Future<bool> delProfile(BuildContext context) async {
    try {
      // Set Image
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('profiles/${info.info.uid}/profile_picture');
      await storageReference.delete();
      print('File Deleted');
      info.info.profileImage = "";
      info.notifyChanges();
      await ProfileService().updateProfile(info.info);
      return true;
    } catch (e) {
      print("Could\'nt delete profile pciture");
      return false;
    }
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
            Profile information = Profile.fromMap(info.info.toMap());
            information.fullName = nameController.text;
            information.username = usernameController.text;
            information.bio = bioController.text;
            information.email = emailController.text;
            information.gender = genderController.text;
            if (information.toMap().toString() !=
                info.info.toMap().toString()) {
              bool value = false;
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Unsaved changes",
                                  style: actionTitle4Style(),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Text(
                                "You have unsaved changes. Are\nyou sure you want to cancel?",
                                style: body2Style(),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[200],
                        ),
                        ListTile(
                          onTap: () {
                            value = true;
                            Navigator.pop(context);
                          },
                          title: Center(
                              child: Text("Yes", style: actionTapStyle())),
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[200],
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.maybePop(context);
                          },
                          title: Center(child: Text("No", style: body3Style())),
                        ),
                      ],
                    ),
                  );
                },
              );
              if (value) {
                print("Exiting with conditions");
                Navigator.maybePop(context);
              }
            } else {
              print("Exiting without conditions");
              Navigator.maybePop(context);
            }
          },
        ),
        title: Text(
          "Edit Profile",
          style: actionTitle3Style(),
        ),
        actions: <Widget>[
          Builder(builder: (BuildContext recContext) {
            return IconButton(
              color: Color(actionColor),
              icon: Icon(Icons.done),
              onPressed: () async {
                Profile information = Profile.fromMap(info.info.toMap());
                information.fullName = nameController.text;
                information.username = usernameController.text;
                information.bio = bioController.text;
                information.email = emailController.text;
                information.gender = genderController.text;
                if (information.toMap().toString() !=
                    info.info.toMap().toString()) {
                  var xx;
                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      ProfileService()
                          .updateProfile(information)
                          .then((answer) {
                        xx = answer;
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  if (xx) {
                    info.updateInfo(information);
                    Navigator.maybePop(context);
                  } else {
                    Scaffold.of(recContext).showSnackBar(
                      SnackBar(
                        content: Text("Something weird happened"),
                      ),
                    );
                  }
                } else
                  Scaffold.of(recContext).showSnackBar(
                    SnackBar(
                      content: Text("No changes made"),
                      duration: Duration(seconds: 1),
                    ),
                  );
              },
            );
          }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ICProfileAvatar(
                // database: FirebaseDatabase.instance,
                // profileOf: data.uid,
                profileURL: info.info.profileImage,
                size: 50,
              ),
            ],
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
                          onTap: () async {
                            await delProfile(context);
                            await Navigator.maybePop(context);
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
            child: TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                suffix: view.isBusy
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 15,
                          maxWidth: 15,
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox(),
                labelText: view.usernameChanged
                    ? view.usernameAvailable
                        ? "Username"
                        : "Username not available"
                    : "Username",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: view.usernameChanged
                        ? view.usernameAvailable ? Colors.grey : Colors.red[600]
                        : Colors.grey,
                  ),
                ),
                labelStyle: TextStyle(
                  color: view.usernameChanged
                      ? view.usernameAvailable ? Colors.grey : Colors.red[600]
                      : Colors.grey,
                ),
              ),
              onChanged: (value) async {
                if (value != info.info.username) {
                  view.toggleBusy(true);
                  if (!view.usernameChanged) {
                    view.setUsernameFieldChange();
                  }
                  await Future.delayed(Duration(milliseconds: 660));
                  bool isAvailable =
                      await GenerateUsername().isUsernameAvailable(value);
                  view.setUsernameAvailable(isAvailable);
                  view.toggleBusy(false);
                }
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
            onTap: () async {
              Object reply;
              // Get gender from page
              reply = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PickGender(
                    receivedGender: genderController.text,
                  ),
                ),
              );
              String repliedGender = reply;
              if (repliedGender.isNotEmpty) {
                genderController.text = repliedGender;
              }
            },
            child: AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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
