import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';

class HorizontalScrollButton extends StatelessWidget {
  const HorizontalScrollButton({
    Key key,
    @required this.buttonText,
    @required this.callback
  }) : super(key: key);

  final String buttonText;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 0.8,
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          )),
          color: Colors.white,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              callback();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
              children: <Widget>[
              Text(buttonText,
                  style: Theme.of(context)
                      .textTheme
                      .display4
                      .copyWith(color: greyAccent)),
              Icon(
                Icons.arrow_forward,
                size: 30,
                color: greyAccent,
              )
            ]),
          ),
        ));
  }
}
