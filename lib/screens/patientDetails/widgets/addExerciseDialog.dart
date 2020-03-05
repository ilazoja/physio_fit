import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/screens/account/providerWrapper/editProfileProviderWrapper.dart';
import 'package:physio_tracker_app/screens/patientDetails/widgets/addExerciseWidget.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/models/user.dart';

class ExerciseDialog {
  ExerciseDialog(BuildContext context) {
    showDialog<BuildContext>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical:
                      MediaQuery.of(context).size.height > 750 ? 25 : 0),
                  child: AddExerciseWidget(
                      onLogin: (bool isVerified, bool isNewUser, String uid) {
                        Navigator.of(context).pop();
                      })),
              Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    child: Icon(Icons.close, color: Colors.white, size: 30),
                    onTap: () => Navigator.pop(context)),
              )
            ],
          );
        });
  }
}
