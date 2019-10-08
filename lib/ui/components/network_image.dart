import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram/commons/styles.dart';

@deprecated
class ICNetworkImage extends StatelessWidget {
  final String imageURL;
  final BoxFit fit;
  final double height;
  final double width;
  const ICNetworkImage(this.imageURL, this.height, this.width, this.fit);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageURL,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        child: icProcessIndicator(context),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
