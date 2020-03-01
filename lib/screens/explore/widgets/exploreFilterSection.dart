import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/categoryFilterButton.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/dateFilterButton.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/priceFilterButton.dart';

class ExploreFilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double containerHeight = MediaQuery.of(context).size.height * 0.06;

    return SliverAppBar(
        floating: true,
        forceElevated: true,
        elevation: 4,
        expandedHeight: 60,
        flexibleSpace: FlexibleSpaceBar(
            background: Container(
          padding: const EdgeInsets.only(right: 10, top: 12, bottom: 12, left: 0),
          height: containerHeight,
          color: Theme.of(context).appBarTheme.color,
          alignment: Alignment.center,
        )));
  }
}
