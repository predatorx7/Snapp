import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNavBarModel extends ChangeNotifier {
  List<Widget> _widgetList;

  List<Widget> get widgetList => _widgetList;

  setWidgetList(List<Widget> widgetList) {
    _widgetList = widgetList;
    notifyListeners();
  }

  addInWidgetList(Widget x) {
    _widgetList.add(x);
    notifyListeners();
  }
}

class CustomNavBar extends StatefulWidget {
  CustomNavBar({
    Key key,
    @required this.items,
    // this.onTap,
    this.currentIndex = 0,
  })  : assert(items != null),
        assert(items.length >= 2),
        assert(0 <= currentIndex && currentIndex < items.length),
        super(key: key);
  final List<CustomNavBarTile> items;
  // final Function onTap;
  final int currentIndex;
  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class CustomNavBarTile {
  Widget tile;
  Widget senseTile;
  bool isActive = false;
  void Function() onTap;

  CustomNavBarTile({
    String imageLocation,
    String activeImageLocation,
    this.onTap,
  });

  CustomNavBarTile.makeTile({
    String imageLocation,
    String activeImageLocation,
  }) {
    this.tile = GestureDetector(
      onTap: onTap,
      child: Expanded(
        child: Image(
          image:
              AssetImage(this.isActive ? activeImageLocation : imageLocation),
        ),
      ),
    );
  }
}

class _CustomNavBarState extends State<CustomNavBar> {
  List<Widget> widgetTile;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  generateTileWidgets(List<CustomNavBarTile> items) {
    List<Widget> tiles;
    CustomNavBarTile x;
    for (var i = 0; i < items.length; i++) {
      x = items[i];
      
      x.isActive = (widget.currentIndex == i);
      print(x.tile.toString());
      // tiles.add(x.tile);
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (BuildContext context) => CustomNavBarModel(),
      child: Consumer(
        builder: (BuildContext context, CustomNavBarModel view, _) {
          return Container(
            height: 50,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: generateTileWidgets(widget.items),
            ),
          );
        },
      ),
    );
  }
}
