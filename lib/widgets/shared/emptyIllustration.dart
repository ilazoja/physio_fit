import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyIllustration extends StatelessWidget {
  const EmptyIllustration({Key key, @required this.image, this.text})
      : super(key: key);

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: SvgPicture.asset(
                image,
                fit: BoxFit.fitWidth,
              )
          ),
        ],
      ),
    );
  }
}
