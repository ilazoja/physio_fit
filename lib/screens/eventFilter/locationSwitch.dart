import 'package:flutter/material.dart';
import 'package:physio_tracker_app/services/location.dart' as location;
import 'package:physio_tracker_app/widgets/shared/standardAlertDialog.dart';

class LocationSwitch extends StatefulWidget {
  @override
  _LocationSwitchState createState() => _LocationSwitchState();
  static bool enableLocationFilter = false;
}

class _LocationSwitchState extends State<LocationSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Switch(
        value: LocationSwitch.enableLocationFilter,
        onChanged: !location.locationPermissionSet
            ? null
            : (bool value) {
                LocationSwitch.enableLocationFilter = value;
                setState(() {
                  if (location.locationPermissionSet) {
                    location.initLocationServices();
                  } else {
                    enableLocationPrompt();
                  }
                });
              },
      ),
      onTap: () {
        if (!location.locationPermissionSet) {
          enableLocationPrompt();
          setState(() {});
        }
      },
    );
  }

  void enableLocationPrompt() {
    StandardAlertDialog(context, 'Enable Location', 'Enable Location Services in App Settings');
  }
}
