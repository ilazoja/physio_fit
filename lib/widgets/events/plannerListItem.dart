import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/widgets/shared/circular_image.dart';

class PlannerListItem extends StatelessWidget {
  PlannerListItem(this.event, this.showTime);

  final Exercise event;
  bool showTime;

  Widget buildEventTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: 'Open Sans',
          fontSize: 17,
          color: Colors.black,
        ),
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildEventDescription(String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
      child: AutoSizeText(description,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Open Sans',
              fontSize: 14,
              color: Colors.black),
          textAlign: TextAlign.left),
    );
  }

  @override
  Widget build(BuildContext context) {
    showTime ??= false;

    return Column(
      children: <Widget>[
        Stack(children: <Widget>[
          Row(children: <Widget>[
            Column(
              children: <Widget>[
                CircularImage(event.imageSrc, height: 60, width: 60),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: getDetails(context)),
              ],
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Divider(
            color: chatTheme.greyColor3,
            height: 5,
            thickness: 1.0,
          ),
        )
      ],
    );
  }

  Widget getDetails(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: AutoSizeText(
                    event.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Open Sans',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left
                  ),
                ),
              ),
              getChip(context)
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: AutoSizeText(convertDate(event.date, showTime),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Open Sans',
                        fontSize: 12,
                        color: Colors.black),
                    textAlign: TextAlign.left),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: AutoSizeText(event.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Open Sans',
                        fontSize: 12,
                        color: Colors.black),
                    textAlign: TextAlign.left),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget getChip(BuildContext context) {
    return Container(
      child: FilterChip(
        shadowColor: Colors.white.withOpacity(0),
        onSelected: (bool j){},
        label:
            Text(event.name, style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white)),
        backgroundColor: getUserRelationColor(context, event.name),
      ),
    );
  }

  Color getUserRelationColor(BuildContext context, String type) {
    switch (type) {
      case 'Favorited':
        return Colors.red[400];
      case 'Attending':
        return Theme.of(context).accentColor;
      case 'Hosting':
        return Theme.of(context).accentColor;
    }
    return Theme.of(context).accentColor;
  }

  String convertDate(DateTime date, bool showTime) {
    DateFormat format = DateFormat('EEEE MMMM d');
    if (showTime) {
      format = DateFormat.jm();
    }
    return format.format(date);
  }
}
