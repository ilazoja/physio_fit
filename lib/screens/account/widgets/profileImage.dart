import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage(this.profileImageStr, {this.profileUploadCallback});

  static const String _pathToAsset = 'assets/images/default_profile_image.png';
  final String profileImageStr;
  final Function profileUploadCallback;

  @override
  Widget build(BuildContext context) {
    const double size = 140.0;
    final BorderRadiusGeometry borderRadius = BorderRadius.circular(80.0);
    final BoxBorder border =
        Border.all(color: Theme.of(context).primaryColorLight, width: 5.0);

    if (profileImageStr == '') {
      return getProfileWidget(context, size, border, borderRadius);
    } else if (profileImageStr != null && profileImageStr.isNotEmpty) {
      return Container(
          width: size,
          height: size,
          child: CachedNetworkImage(
              imageUrl: profileImageStr,
              placeholder: (BuildContext context, String url) => const Center(
                  heightFactor: 0.4, child: CircularProgressIndicator()),
              imageBuilder:
                  (BuildContext context, ImageProvider imageProvider) =>
                      Container(
                          decoration: BoxDecoration(
                              border: border,
                              borderRadius: borderRadius,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)))));
    } else {
      return getProfileWidget(context, size, border, borderRadius);
    }
  }

  DecorationImage getImage() {
    return const DecorationImage(
        image: AssetImage(_pathToAsset), fit: BoxFit.cover);
  }

  Widget getProfileWidget(BuildContext context, double size, BoxBorder border,
      BorderRadiusGeometry borderRadius) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(border: border, borderRadius: borderRadius),
        child: Center(
            child: Icon(
          Icons.add_a_photo,
          size: 75,
          color: Theme.of(context).accentColor,
        )));
  }
}
