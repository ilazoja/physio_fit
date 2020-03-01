import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

///Add gradient to given network image and stacks on top children
///If imageSrc is null, default image used
class NetworkImageGradient extends StatelessWidget {
  const NetworkImageGradient({
    Key key,
    @required this.imageSrc,
    @required this.topDark,
    @required this.containerHeight,
    @required this.gradientColor,
    this.children,
  }) : super(key: key);

  final String imageSrc;
  final bool topDark;
  final double containerHeight;
  final Color gradientColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<Widget> allWidget = <Widget>[
      Container(
          height: containerHeight,
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
                  imageUrl: imageSrc,
                  placeholder: (BuildContext context, String url) => Center(
                      heightFactor: 0.4,
                      child: const CircularProgressIndicator()),
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Icon(Icons.error),
                  fit: BoxFit.cover,
                )
              ),
      Container(
        height: containerHeight + 0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: topDark
                    ? const FractionalOffset(0.5, 0.3)
                    : FractionalOffset.topCenter,
                end: topDark
                    ? FractionalOffset.topCenter
                    : FractionalOffset.bottomCenter,
                colors: <Color>[
              Colors.transparent.withOpacity(0.0),
              gradientColor.withOpacity(0.7),
            ],
                stops: const <double>[
              0.0,
              1.0
            ])),
      ),
      topDark
          ? Container(
              height: containerHeight + 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: const FractionalOffset(0.5, 0.5),
                      end: FractionalOffset.bottomCenter,
                      colors: <Color>[
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(1),
                  ],
                      stops: const <double>[
                    0.0,
                    1.0
                  ])),
            )
          : Container(),
    ];

    if (children != null) {
      if (children.isNotEmpty) {
        allWidget.addAll(children);
      }
    }

    return Stack(children: allWidget);
  }

}
