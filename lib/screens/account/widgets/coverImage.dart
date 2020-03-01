import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../copyDeck.dart' as copy;

class CoverImage extends StatelessWidget {
  const CoverImage({this.screenSize, this.coverImageStr, this.isVerified});

  final Size screenSize;
  final String coverImageStr;
  final bool isVerified;

  static const double ASPECT_RATIO = 4.6;
  static const String _pathToAsset = 'assets/images/default_cover_photo.jpg';

  @override
  Widget build(BuildContext context) {
    print(coverImageStr);
    if (coverImageStr != null && coverImageStr.isNotEmpty) {
      return Container(
        height: screenSize.height / ASPECT_RATIO,
        width: MediaQuery.of(context).size.width,
        child: isVerified
            ? getCachedImage()
            : Banner(
                message: copy.isNotVerified,
                location: BannerLocation.topStart,
                child: getCachedImage()
              ),
      );
    } else {
      return getCoverWidget(context);
    }
  }

  Widget getCachedImage(){
    return CachedNetworkImage(
      placeholder: (BuildContext context, String url) => const Center(
          heightFactor: 0.4, child: CircularProgressIndicator()),
      imageUrl: coverImageStr,
      fit: BoxFit.cover,
    );
  }

  Widget getCoverWidget(BuildContext context) {
    return Container(
        height: screenSize.height / ASPECT_RATIO,
        child: isVerified
            ? null
            : Banner(
                message: copy.isNotVerified,
                location: BannerLocation.topStart,
              ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(image: getImage()));
  }

  DecorationImage getImage() {
    return const DecorationImage(
        image: AssetImage(_pathToAsset), fit: BoxFit.cover);
  }
}
