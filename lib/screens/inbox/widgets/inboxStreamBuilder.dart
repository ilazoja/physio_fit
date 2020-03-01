import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/screens/inbox/providerWrapper/notificationProviderWrapper.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/helpers/widgetHelpers.dart';
import '../../../models/user.dart';
import '../providerWrapper/messagingProviderWrapper.dart';

class InboxStreamBuilder extends StatefulWidget {
  InboxStreamBuilder({Key key, this.tab}) : super(key: key);
  final int tab;

  @override
  _InboxStreamBuilderState createState() => _InboxStreamBuilderState(tab: tab);
}

class _InboxStreamBuilderState extends State<InboxStreamBuilder> {
  _InboxStreamBuilderState({this.tab});

  int tab;

  @override
  Widget build(BuildContext context) {
    tab = (tab == null) ? 0 : tab;
    final User _currUserModel = Provider.of<User>(context);
    if (_currUserModel != null) {
      return Container(
          child: Column(
        children: <Widget>[
          SizedBox(
              width: double.infinity,
              child: CupertinoSegmentedControl<int>(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 10),
                selectedColor: Theme.of(context).accentColor,
                pressedColor: Theme.of(context).splashColor,
                borderColor: Theme.of(context).accentColor,
                children: WidgetHelpers.getTabWidgets(
                    'Messaging',
                    'Notificat'
                        'ions',
                    context),
                groupValue: tab,
                onValueChanged: (int value) {
                  setState(() => tab = value);
                },
              )),
          tab == 0
              ? Expanded(child: MessagingProviderWrapper(user: _currUserModel))
              : Expanded(child: NotificationProviderWrapper()),
        ],
      ));
    }
    return Container();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
