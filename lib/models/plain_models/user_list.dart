import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/models/plain_models/profile.dart';
import 'package:scoped_model/scoped_model.dart';

class UserListModel extends Model {
  final DatabaseReference dr =
  FirebaseDatabase.instance.reference().child("profiles");
  Map<dynamic, Profile> _results = {};
  Map<dynamic, Profile> get results => _results;
  UserListModel(List<dynamic> list){
    this.fetch(list);
  }
  Future<void> fetch(List<dynamic> users) async {
    this._results = {};
    notifyListeners();
    for (dynamic uid in users){
      await dr.child(uid).once().then(
            (DataSnapshot values) {
          if (values.value != null) {
            this._results.addAll({uid: Profile.createFromMap(values.value)});
            notifyListeners();
          }
        },
      );
    }
  }

}
