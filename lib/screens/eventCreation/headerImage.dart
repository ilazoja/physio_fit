import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';

/// Add gradient to given network image and stacks on top children
/// If imageSrc is null, default image used
class HeaderImage extends StatelessWidget {
  const HeaderImage({
    Key key,
    @required this.imageSrcUrls,
    @required this.containerHeight,
  }) : super(key: key);

  final List<dynamic> imageSrcUrls;
  final double containerHeight;

  static const String _pathToAsset = 'assets/images/default.jpg';

  @override
  Widget build(BuildContext context) {
    return imageSrcUrls == null
        ? Container(
            height: containerHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage(_pathToAsset), fit: BoxFit.cover)),
          )
        : SizedBox(
            height: containerHeight,
            width: MediaQuery.of(context).size.width,
            child: Carousel(
              images: getAllCachedImages(imageSrcUrls),
              dotSize: 10.0,
              dotIncreaseSize: 1.1,
              dotIncreasedColor: Theme.of(context).accentColor,
              dotSpacing: 15.0,
              dotColor: Theme.of(context).accentColor.withOpacity(0.5),
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.transparent,
              borderRadius: false,
              autoplay: false,
            ));
  }

  List<CachedNetworkImage> getAllCachedImages(List<dynamic> imgUrls) {
    final List<CachedNetworkImage> allCachedImages = <CachedNetworkImage>[];
    for (dynamic imgUrl in imgUrls) {
      allCachedImages.add(CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder: (BuildContext context, String url) =>
            Center(heightFactor: 0.4, child: const CircularProgressIndicator()),
        errorWidget: (BuildContext context, String url, Object error) =>
            Icon(Icons.error),
        fit: BoxFit.cover,
      ));
    }

    return allCachedImages;
  }
}
