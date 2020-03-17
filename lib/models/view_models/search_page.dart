import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/repository/profile.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchModel extends Model {
  final DatabaseReference dr =
      FirebaseDatabase.instance.reference().child("profiles");
  Map<String, Profile> _results = {};
  Map<String, Profile> get results => _results;

  Future<void> search(String key) async {
    if (key.isEmpty) {
      print('No search keyword entered');
      return;
    }
    this._results = {};
    notifyListeners();
    await queryPerform("username", key);
    await queryPerform("email", key);
    await queryPerform("fullName", key);
    await queryPerform(
        "fullName", key.substring(0, 1).toUpperCase() + key.substring(1));
  }

  Future<void> queryPerform(String orderBy, key) async {
    dr.orderByChild(orderBy).startAt(key).once().then(
      (DataSnapshot values) {
        if (values.value != null) {
          for (var i in values.value.keys.toList()) {
            String _filter;
            _filter = values.value[i][orderBy];
            if (_filter.startsWith(key)) {
              this._results.addAll({i: Profile.fromMap(values.value[i])});
            }
          }
          notifyListeners();
        }
      },
    );
  }
}
