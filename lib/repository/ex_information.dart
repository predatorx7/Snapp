import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/repository/information.dart';
import '../models/plain_models/profile.dart';

class ExInfoRepo extends InfoRepo {
  bool _observerFollows = false;
  bool _isBusy = false;

  ExInfoRepo(String userUID) : super(userUID);

  ExInfoRepo.setInfo(Profile information) : super.setInfo(information);

  bool get isBusy => _isBusy;

  DatabaseReference dr = FirebaseDatabase.instance.reference();
  bool get observerFollows => _observerFollows;

  setFollow(bool value) {
    _observerFollows = value;
    notifyListeners();
  }

  setBusyStatus(bool busy) {
    this._isBusy = busy;
    notifyListeners();
  }

  Future doFollow(Profile observer) async {
    setBusyStatus(true);
    try {
      await dr.child("followers_of/${this.info.uid}").push().set(observer.uid);
      await dr.child("followings_of/${observer.uid}").push().set(this.info.uid);
      _observerFollows = true;
      this.followers.add(observer);
    } catch (e) {}
    this._isBusy = false;
    notifyListeners();
  }

  Profile getFollower(String uid) {
    for (Profile follower in this.followers) {
      if (follower.uid == uid) {
        return follower;
      }
    }
    return null;
  }

  doUnFollow(Profile observer) async {
    setBusyStatus(true);
    try {
      await dr
          .child("followers_of/${this.info.uid}")
          .once()
          .then((DataSnapshot value) {
        print("Recieved this user's profile ${value.value.toString()}");
        for (var i in value.value.keys.toList()) {
          if (value.value[i] == observer.uid) {
            dr.child("${this.info.uid}/followers/$i").remove();
            break;
          }
        }
      });
      await dr
          .child("followings_of/${observer.uid}")
          .once()
          .then((DataSnapshot value) {
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
    this._isBusy = false;
    notifyListeners();
  }
}
