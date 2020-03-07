import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/subHeading.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PerformExercise extends StatelessWidget {
  const PerformExercise({this.callback, this.buttonText});
  final String buttonText;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {

    return   Scaffold(
        body: Stack(
          children: <Widget>[
              Stack(
                children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 10, bottom: 40),
                              child: SizedBox(
                                height: 43.0,
                                child: FloatingActionButton.extended(
                                    icon: Icon(Icons.add),
                                    label: Text(buttonText),
                                    onPressed: callback
                                ),
                              ))
                          ],
                        ),
                  )
                ],
              ),
          ],
        ));

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 10, bottom: 40),
        child: SizedBox(
          height: 43.0,
          child: FloatingActionButton.extended(
              icon: Icon(Icons.add),
              label: Text(buttonText),
              onPressed: callback
          ),
        ))],
      ),
    );
  }
}
