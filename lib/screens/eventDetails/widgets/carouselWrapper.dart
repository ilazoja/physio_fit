import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/networkImageGradient.dart';

class CarouselWrapper extends StatelessWidget {
  CarouselWrapper(
      {@required this.images, this.child, @required this.containerHeight});

  final List<dynamic> images;
  final Widget child;
  double containerHeight;

  @override
  Widget build(BuildContext context) {
    containerHeight = containerHeight - 25;
    return Stack(
      children: <Widget>[
        images.length > 1
            ? SizedBox(
                height: containerHeight,
                width: MediaQuery.of(context).size.width,
                child: Carousel(
                  images: getAllCachedImages(images, containerHeight),
                  dotSize: 10.0,
                  dotIncreaseSize: 1.1,
                  dotIncreasedColor: Theme.of(context).accentColor,
                  dotSpacing: 15.0,
                  dotColor: Theme.of(context).accentColor.withOpacity(0.5),
                  dotVerticalPadding: 60,
                  dotBgColor: Colors.transparent,
                  borderRadius: false,
                  autoplay: false,
                ))
            : getNetworkImage(images[0], containerHeight),
        child
      ],
    );
  }

  List<dynamic> getAllCachedImages(
      List<dynamic> imgUrls, double containerHeight) {
    final List<dynamic> allCachedImages = <dynamic>[];
    for (dynamic imgUrl in imgUrls) {
      allCachedImages.add(getNetworkImage(imgUrl, containerHeight));
    }

    return allCachedImages;
  }

  Widget getNetworkImage(dynamic imgUrl, double containerHeight) {
    return NetworkImageGradient(
        imageSrc: imgUrl,
        containerHeight: containerHeight,
        topDark: true,
        gradientColor: Colors.black);
  }
}
