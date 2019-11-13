import 'package:flutter/material.dart';

BottomNavigationBarItem icBottomNavBarItem({Image image, Image activeImage}) {
  return BottomNavigationBarItem(
    title: Container(height: 0.0),
    icon: image,
    activeIcon: activeImage,
  );
}

class ICBottomNavBar extends StatefulWidget {
  ICBottomNavBar({
    Key key,
    @required this.items,
    this.onTap,
    this.currentIndex = 0,
  })  : assert(items != null),
        assert(items.length >= 2),
        assert(0 <= currentIndex && currentIndex < items.length),
        super(key: key);

  final List<BottomNavigationBarItem> items;
  final ValueChanged<int> onTap;
  final int currentIndex;

  @override
  _ICBottomNavBarState createState() => _ICBottomNavBarState();
}

class _ICBottomNavBarState extends State<ICBottomNavBar> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _createTiles() {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    assert(localizations != null);

    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < widget.items.length; i++) {
      tiles.add(_BottomNavigationTile(
        widget.items[i],
        onTap: () {
          if (widget.onTap != null) widget.onTap(i);
        },
        selected: i == widget.currentIndex,
        indexLabel: localizations.tabLabel(
            tabIndex: i + 1, tabCount: widget.items.length),
      ));
    }
    return tiles;
  }

  Widget _createContainer(List<Widget> tiles) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasMediaQuery(context));
    return Semantics(
      explicitChildNodes: true,
      child: Material(
        elevation: 5,
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: kBottomNavigationBarHeight),
          child: Material(
            // Splashes.
            type: MaterialType.transparency,
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: _createContainer(_createTiles()),
            ),
          ),
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({
    Key key,
    @required this.selected,
    @required this.item,
  })  : assert(selected != null),
        assert(item != null),
        super(key: key);

  final bool selected;
  final BottomNavigationBarItem item;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: Container(
        child: selected ? item.activeIcon : item.icon,
      ),
    );
  }
}

class _BottomNavigationTile extends StatelessWidget {
  const _BottomNavigationTile(
    this.item, {
    this.onTap,
    this.selected = false,
    this.indexLabel,
  })  : assert(item != null),
        assert(selected != null);

  final BottomNavigationBarItem item;
  final VoidCallback onTap;
  final bool selected;
  final String indexLabel;

  @override
  Widget build(BuildContext context) {
    int size = 1;
    return Expanded(
      flex: size,
      child: Semantics(
        container: true,
        selected: selected,
        child: Focus(
          child: Stack(
            children: <Widget>[
              InkResponse(
                onTap: onTap,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _TileIcon(
                        selected: selected,
                        item: item,
                      ),
                    ],
                  ),
                ),
              ),
              Semantics(
                label: indexLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
