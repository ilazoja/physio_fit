import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/screens/settings/preferencesSetting.dart';
import 'package:physio_tracker_app/widgets/shared/standardButton.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PreferenceSetting prefSettings = PreferenceSetting();

    return Scaffold(
        appBar: AppBarPage(title: copy.settingsHeadings),
        body: Container(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              prefSettings,
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: StandardButton(
                      text: 'Save',
                      onPressed: () {
                        prefSettings.savePreferences().then((void val) {
                          Navigator.of(context).pop();
                        });
                      })),
            ],
          ),
        ));
  }

// void showSavedDialog(BuildContext context) {
//   showDialog<Dialog>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Settings saved!'),
//           actions: <Widget>[
//             FlatButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       });
// }
}
