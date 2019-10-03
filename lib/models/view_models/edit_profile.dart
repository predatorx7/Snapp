import 'package:instagram/models/plain_models/profile.dart';
import 'package:scoped_model/scoped_model.dart';

class EditProfileModel extends Model {
  Profile _information;

  Profile get information => _information;

  setInformation(Profile information) {
    _information = information;
    notifyListeners();
  }
}
