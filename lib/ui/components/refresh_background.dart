import 'package:flutter/material.dart';

class RefreshBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox.expand(
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
