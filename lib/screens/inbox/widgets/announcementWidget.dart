import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/announcement.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/screens/eventDetails/providerWrapper/eventDetailsProviderWrapper.dart';

class AnnouncementListItem extends StatelessWidget {
  AnnouncementListItem({Key key, @required this.announcement})
      : super(key: key);

  final Announcement announcement;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return StreamBuilder<Exercise>(
        stream: CloudDatabase.streamEvent(announcement.eventId),
        builder: (BuildContext context, AsyncSnapshot<Exercise> snapshot) {
          if (snapshot.hasData) {
            return Container(
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildContent(context, snapshot.data),
                          Divider(
                            color: chatTheme.greyColor3,
                            height: 10.0,
                            thickness: 1.0,
                          )
                        ])));
          } else {
            return Container();
          }
        });
  }

  Widget buildContent(BuildContext context, Exercise event) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
            pageRoute: EventDetailsProviderWrapper(), arguments: event.id));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Stack(children: <Widget>[
          Row(children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(event.imageSrc),
                  backgroundColor: Colors.transparent,
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: buildAnnouncementDetails(announcement, context)),
                ],
              ),
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ]),
      ),
    );
  }

  Widget buildAnnouncementDetails(
      Announcement announcement, BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    announcement.title,
                    style: chatTheme.convoHeading,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: AutoSizeText(announcement.message,
                    style: chatTheme.convoBody,
                    textAlign: TextAlign.left,),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                getTime(announcement.timestamp),
                style: chatTheme.convoTime,
                textAlign: TextAlign.right,
              ),
            )
          ],
        )
      ],
    );
  }

  String getTime(String timestamp) {
    return DateFormat('dd MMM kk:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }
}
