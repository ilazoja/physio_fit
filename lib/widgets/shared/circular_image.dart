import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  const CircularImage(this.imageUrl,
  {this.height = 100, this.width = 100, this.iconSize = 40, this.isAddProfileImage = false});

  final double width, height, iconSize;
  final String imageUrl;
  final bool isAddProfileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            // Circle shape
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5.0,
              ),
            ]),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (BuildContext context, String url) => Center(
                heightFactor: 0.4, child: getDefaultIcon(context)),
            errorWidget: (BuildContext context, String url, Object error) =>
                getDefaultIcon(context),
            fit: BoxFit.cover,
          ),
        ));
  }

  Icon getDefaultIcon(BuildContext context) {
    return Icon(
      isAddProfileImage ? Icons.add_a_photo : Icons.person,
      size: iconSize,
      color: Theme.of(context).accentColor,
    );
  }
}
