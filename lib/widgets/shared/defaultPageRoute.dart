import 'package:flutter/cupertino.dart';

class DefaultPageRoute<T> extends CupertinoPageRoute<T> {
  DefaultPageRoute({this.arguments, @required this.pageRoute})
      : super(
            builder: (BuildContext context) => pageRoute,
            settings: RouteSettings(arguments: arguments));

  final Object arguments;
  final Widget pageRoute;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0),
          end: Offset.zero,
        ).animate(animation),
        child: pageRoute);
  }
}
