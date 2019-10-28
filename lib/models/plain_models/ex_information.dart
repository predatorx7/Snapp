import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/models/plain_models/information.dart';
import 'profile.dart';

class ExInfoModel extends InfoModel{
  bool _observerFollows = false;
  DatabaseReference dr =
      FirebaseDatabase.instance.reference().child('profiles');
  bool get observerFollows => _observerFollows;

  ExInfoModel();

  setFollow(bool value) {
    _observerFollows = value;
    notifyListeners();
  }

  doFollow(Profile observer) {
    try {
      dr.child("${this.info.uid}/followers").push().set(observer.uid);
      dr.child("${observer.uid}/follows").push().set(this.info.uid);
      _observerFollows = true;
      this.info.followers.add(observer.uid);
    } catch (e) {}
    notifyListeners();
  }

  doUnFollow(Profile observer) async {
    try {
      await dr.child("${this.info.uid}/followers").once().then((DataSnapshot value) {
        print("Recieved this user's profile ${value.value.toString()}");
        for (var i in value.value.keys.toList()) {
          if (value.value[i] == observer.uid) {
            dr.child("${this.info.uid}/followers/$i").remove();
            break;
          }
        }
      });
      await dr.child("${observer.uid}/follows").once().then((DataSnapshot value) {
        print("Recieved observer's profile ${value.value.toString()}");
        for (var i in value.value.keys.toList()) {
          if (value.value[i] == this.info.uid) {
            dr.child("${observer.uid}/followers/$i").remove();
            break;
          }
        }
      });
      _observerFollows = false;
    } catch (e) {}
    notifyListeners();
  }
}
