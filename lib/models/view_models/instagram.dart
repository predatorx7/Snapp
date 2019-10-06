import 'package:scoped_model/scoped_model.dart';

class InstagramPaginationModel extends Model {
  int _viewIndex = 0;

  int get viewIndex => _viewIndex;

  setIndex(int index) {
    _viewIndex = index;
    notifyListeners();
  }
}
