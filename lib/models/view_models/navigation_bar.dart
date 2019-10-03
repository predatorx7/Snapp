import 'package:scoped_model/scoped_model.dart';

class BottomNavigationBarModel extends Model {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  setCurrentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }
}
