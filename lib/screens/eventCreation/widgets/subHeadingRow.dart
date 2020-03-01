import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SubHeadingRow extends StatelessWidget {
  const SubHeadingRow({Key key, @required this.heading}) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.black12,
      child: AutoSizeText(heading,
          style: Theme.of(context).textTheme.body1.copyWith(
              fontSize: 16.0,
              color: Colors.black54,
              fontWeight: FontWeight.bold)),
    );
  }
}
