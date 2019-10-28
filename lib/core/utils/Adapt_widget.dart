/// This Adapt Util will give values to the Sliver to Adapt with data in FlexBar
class Adapt {
  double size;
  Adapt({this.size = 0});
  Adapt.addSize(double addSize) {
    this.size += addSize;
  }
  double withText({String text, double fontSize = 8}) {
    if (text?.isNotEmpty ?? false) {
      double numberOfLines = '\n'.allMatches(text).length + 1.0;
      return this.size + (numberOfLines * fontSize);
    } else {
      return this.size;
    }
  }
}
