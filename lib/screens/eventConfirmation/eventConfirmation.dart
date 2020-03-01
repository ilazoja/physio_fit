import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/widgets/events/getIconAndHeadingRow.dart';
import 'package:physio_tracker_app/widgets/events/getItemTextRow.dart';
import 'package:intl/intl.dart';
import '../../copyDeck.dart' as copy;
import '../../widgets/shared/networkImageGradient.dart';
import '../../widgets/shared/standardButton.dart';

class EventConfirmation extends StatelessWidget {
  const EventConfirmation(
      {@required this.event,
        @required this.confirmationSuccess,
        @required this.cancellation,
        @required this.cancelByDate});

  final Event event;
  final bool confirmationSuccess;
  final bool cancellation;
  final DateTime cancelByDate;

  @override
  Widget build(BuildContext context) {
    final List<Widget> listViewItems = <Widget>[];
    listViewItems.add(Row(children: <Widget>[
      Expanded(
        child: AutoSizeText(
          confirmationSuccess
              ? cancellation
              ? copy.cancellationConfirm
              : copy.confirmationSuccess
              : cancellation ? copy.cancellationFail : copy.confirmationFail,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    ]));
    // Event Cancellation
    listViewItems.add(const Padding(padding: EdgeInsets.all(2)));
    listViewItems.add(Row(
      children: <Widget>[
        Expanded(
            child: AutoSizeText(event.title,
                style: Theme.of(context)
                    .textTheme
                    .display4
                    .copyWith(fontStyle: FontStyle.italic)))
      ],
    ));
    if (!cancellation) {
      listViewItems.add(_getDivider());
      listViewItems.add(GetIconAndHeadingRow(
          headingIcon: Icons.calendar_today,
          headingText: 'Start Date and Time'));
      listViewItems.add(GetItemTextRow(
          bodyText: DateFormat.yMMMMd('en_US').add_jm().format(event.date)));
      listViewItems.add(const Padding(padding: EdgeInsets.all(5)));
      listViewItems.add(GetIconAndHeadingRow(
          headingIcon: Icons.cancel, headingText: copy.cancellationPolicy));
      if (cancelByDate != event.date) {
        listViewItems.add(GetItemTextRow(
            bodyText: copy.cancelBy +
                DateFormat.yMMMMd('en_US')
                    .add_jm()
                    .format(cancelByDate)));
        if (event.cancellationPolicy.isNotEmpty) {
          listViewItems.add(GetItemTextRow(bodyText: event.cancellationPolicy));
        }
      } else {
        listViewItems.add(GetItemTextRow(
          bodyText: copy.noCancellationPolicy,
        ));
      }
    }
    return Scaffold(
        floatingActionButton: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            child: StandardButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                text: copy.closeConfirmation)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: ListView(
                padding: const EdgeInsets.only(bottom: 5.0),
                physics: const ClampingScrollPhysics(),
                children: <Widget>[
                  NetworkImageGradient(
                    imageSrc: event.imageSrc,
                    topDark: true,
                    containerHeight: (MediaQuery.of(context).size.height) / 3,
                    gradientColor: Colors.black,
                    children: <Widget>[
                      Container(
                          height: (MediaQuery.of(context).size.height) / 3,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 15, top: 35),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
                    child: Column(children: listViewItems),
                  ),
                ])));
  }

  Widget _getDivider() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: const Divider());
  }
}