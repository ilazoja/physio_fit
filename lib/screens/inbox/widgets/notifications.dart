import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/widgets/shared/emptyIllustration.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/models/announcement.dart';
import 'package:physio_tracker_app/screens/inbox/widgets/announcementWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  static const String backgroundImage =
      'assets/illustrations/noNotificationScreen.svg';

  @override
  Widget build(BuildContext context) {
    final List<Announcement> _announcements =
        Provider.of<List<Announcement>>(context);
    return _announcements == null || _announcements.isEmpty
        ? const EmptyIllustration(image: backgroundImage)
        : Container(
            child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: getWidgets(context, _announcements)),
            ),
          ]));
  }

  List<Widget> getWidgets(
      BuildContext context, List<Announcement> _announcements) {
    final List<Widget> list = <Widget>[];
    if (_announcements != null) {
      for (Announcement a in _announcements) {
        list.add(AnnouncementListItem(announcement: a));
      }
    }
    return list;
  }
}
