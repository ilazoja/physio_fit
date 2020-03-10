import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:physio_tracker_app/copyDeck.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/imuAlignment.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';
import 'package:physio_tracker_app/imu_processing/alignment_profile.dart';
import 'package:physio_tracker_app/widgets/shared/subHeading.dart';
import 'package:physio_tracker_app/imu_processing/stationary_detector.dart';

class BleBNO080 extends StatefulWidget {
  BleBNO080({Key key, this.device, @required this.exercise, @required this.angleMetadata}) : super(key: key);
  final BluetoothDevice device;
  final Exercise exercise;
  final Map<String, List<double>> angleMetadata;
  Stream<List<int>> sensor1Stream;
  List<vector_math.Quaternion> sensorValues = <vector_math.Quaternion>[];

  @override
  State<StatefulWidget> createState() => BleBNO080State();
}

class BleBNO080State extends State<BleBNO080> {
  final String serviceUUID = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  final String sensor1CharUUID = 'df67ff1a-718f-11e7-8cf7-a6006ad3dba0';
  // final String sensor2CharUUID = '58f7db38-8ad9-4d58-98bd-135e3a656e59';
  // final String sensor3CharUUID = '677db79f-f2ff-4081-952f-1eb2d2e3409d';
  // final String sensor4CharUUID = 'efc8b65a-bbe0-4061-9862-671878bbe10a';
  // final String sensor5CharUUID = 'ee9fdbe4-d2fd-469a-afef-b8b75fd07dd1';
  bool isReady;
  StationaryDetector stationaryDetector = StationaryDetector();
  AlignmentProfile alignmentProfile;

  bool userIsStationary;
  bool globalStationaryFlag;
  // Stream<List<int>> sensor2Stream;
  // Stream<List<int>> sensor3Stream;
  // Stream<List<int>> sensor4Stream;
  // Stream<List<int>> sensor5Stream;

  @override
  void initState() {
    super.initState();
    isReady = false;
    userIsStationary = false;
    globalStationaryFlag = false;
    for(int i = 0; i < 5; i++)
    {
      widget.sensorValues.add(vector_math.Quaternion.identity());
    }
    connectToDevice();
  }

  Future<void> connectToDevice() async {
    if (widget.device == null) {
      popToBefore();
      return;
    }

    await widget.device.connect();
    discoverServices();
    // _listen();
  }

  void disconnectFromDevice() {
    if (widget.device == null) {
      popToBefore();
      return;
    }

    widget.device.disconnect();
  }

  Future<void> discoverServices() async {
    if (widget.device == null) {
      popToBefore();
      return;
    }

    final List<BluetoothService> services = await widget.device.discoverServices();
    for(BluetoothService service in services) {
      if (service.uuid.toString() == serviceUUID) {
        for(BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == sensor1CharUUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            widget.sensor1Stream = characteristic.value;
            }
            setState(() {
            isReady = true;
            });
          }
        }
      }

    if (!isReady) {
      popToBefore();
    }
  }

  void popToBefore() {
    Navigator.of(context).pop(true);
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to disconnect device and go back?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No')),
                FlatButton(
                    onPressed: () {
                      disconnectFromDevice();
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes')),
              ],
            ) ??
            false);
  }

  double roundDouble(double value, int places){
   final double mod = pow(10.0, places);
   return ((value * mod).round().toDouble()) / mod;
}

  // Order of the data list that will come through
  // [Chest Quaternion, Left Femur Quaternion, Left Tibia Quaternion, Right Femur Quaternion, Right Tibia Quaternion]
  void _dataParser(List<int> dataFromDevice) {
    const int listFinalSize = 20;
    double w;
    double x;
    double y;
    double z;

    final String quatString = utf8.decode(dataFromDevice);
    final List<String> quatList = quatString.split(',');
    for(int j = 0; j < quatList.length / 4; j++)
    {
      for(int i = 0; i < quatList.length - 1; i += 4)
      {
        w = double.tryParse(quatList[i]) ?? 0;
        x = double.tryParse(quatList[i+1]) ?? 0;
        y = double.tryParse(quatList[i+2]) ?? 0;
        z = double.tryParse(quatList[i+3]) ?? 0;
        widget.sensorValues.insert(j, vector_math.Quaternion(x, y, z, w));
        widget.sensorValues[j].normalize();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('BNO080 Sensor'),
        ),
        body: Container(
            child: !isReady
                ? Container(child: Center(
                    child: Stack(
                        children: <Widget>[
                          Column(children: <Widget>[
                            Padding (
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                              child: SizedBox(
                                child: CircularProgressIndicator(),
                                height: 200.0,
                                width: 200.0,
                              )
                            ),
                            Padding (
                              padding: EdgeInsets.fromLTRB(20, 30, 0, 10),
                              child: const
                              Text('Sensor Alignment Pending', style:
                                TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Open Sans',
                                  fontSize: 20
                                )
                            )),
                            Padding (
                              padding: EdgeInsets.fromLTRB(20, 30, 0, 10),
                              child: const
                              Text('Please Stand Still', style:
                                TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Open Sans',
                                  fontSize: 20
                                )
                            )),
                            Padding (
                              padding: EdgeInsets.fromLTRB(20, 30, 0, 10),
                              child: const
                              Text('Place Legs Shoulder Width Apart', style:
                                TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Open Sans',
                                  fontSize: 20
                                )
                            )),
                    ])],
                )))
                : Container(
                    child: StreamBuilder<List<int>>(
                      stream: widget.sensor1Stream,
                      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot1) {
                        if (snapshot1.hasError)
                          return Text('Error: ${snapshot1.error}');

                        if (snapshot1.connectionState == ConnectionState.active) {
                          _dataParser(snapshot1.data);
                          userIsStationary = stationaryDetector.isUserStationary(widget.sensorValues[0], widget.sensorValues[1], widget.sensorValues[2], widget.sensorValues[3], widget.sensorValues[4]);
                          if(userIsStationary || globalStationaryFlag)
                          {
                            globalStationaryFlag = true;
                            widget.sensorValues[0] = vector_math.Quaternion(-0.461730957031250,-0.546997070312500,-0.453002929687500,0.531433105468750);
                            widget.sensorValues[1] = vector_math.Quaternion(0.089477539062500,-0.704406738281250,0.070739746093750,0.700561523437500);
                            alignmentProfile = AlignmentProfile(widget.sensorValues[0], widget.sensorValues[1], widget.sensorValues[2], widget.sensorValues[3], widget.sensorValues[4]);
                            isReady = true;
                            return
                              ImuAlignment(
                                alignmentProfile: alignmentProfile,
                                angleMetadata: angleMetaData,
                                isReady: isReady,
                                sensorValues: widget.sensorValues,
                                exercise: widget.exercise
                              );
                          }
                          else
                          {
                            return Text(snapshot1.data.toString());
                          }
                          } else {
                          return Center(
                                  child: Stack(
                                     children: <Widget>[
                                       Column(children: <Widget>[
                                          SubHeading(
                                            heading: "Loading"
                                          ),
                                        CircularProgressIndicator(strokeWidth: 14),
                                      ])],
                          ));
                        }
                      },
                    ),
                  )),
      ),
    );
  }

  void _onAfterBuild(BuildContext context){
    Navigator.of(context)
          .push<dynamic>(MaterialPageRoute<dynamic>(builder: (context) {
            return ImuAlignment(
              alignmentProfile: alignmentProfile,
              angleMetadata: angleMetaData,
              isReady: isReady,
              sensorValues: widget.sensorValues,
              exercise: widget.exercise,
            );
    }));
  }

  Widget createSubHeading(String subHeading) {
    return SliverToBoxAdapter(
        child: SubHeading(
          heading: subHeading,
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: _onWillPop,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text('BNO080 Sensor'),
  //       ),
  //       body: Container(
  //           child: !isReady
  //               ? Center(
  //                   child: Text(
  //                     "Waiting...",
  //                     style: TextStyle(fontSize: 24, color: Colors.red),
  //                   ),
  //                 )
  //               : Container(
  //                   child: StreamBuilder<List<int>>(
  //                     stream: sensor1Stream,
  //                     builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot1) {
  //                       if (snapshot1.hasError)
  //                         return Text('Error: ${snapshot1.error}');

  //                       if (snapshot1.connectionState == ConnectionState.active) {
  //                         final vector_math.Quaternion sensor1Values = _dataParser(snapshot1.data);

  //                         return StreamBuilder<List<int>>(
  //                             stream: sensor2Stream,
  //                             builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot2) {
  //                               if (snapshot1.hasError)
  //                                 return Text('Error: ${snapshot1.error}');

  //                               if (snapshot2.connectionState == ConnectionState.active) {
  //                                 final vector_math.Quaternion sensor2Values = _dataParser(snapshot2.data);

  //                                 return Center(
  //                                     child: Stack(
  //                                   children: <Widget>[
  //                                     Column(children: <Widget>[
  //                                       const Text('Current value from Sensor',
  //                                           style: TextStyle(fontSize: 14)),
  //                                       Text('${roundDouble(sensor1Values.w, 7)}',
  //                                           style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                               fontSize: 16)),
  //                                       Text('${roundDouble(sensor1Values.x, 7)}',
  //                                           style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                               fontSize: 16)),
  //                                       Text('${roundDouble(sensor2Values.y, 7)}',
  //                                           style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                               fontSize: 16)),
  //                                       Text('${roundDouble(sensor2Values.z, 7)}',
  //                                           style: TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                               fontSize: 16))
  //                                     ]),
  //                                   ],
  //                                 ));
  //                               } else {
  //                                 return Text('Check the stream');
  //                               }
  //                             },
  //                           );
  //                       } else {
  //                         return Text('Check the stream');
  //                       }
  //                     },
  //                   ),
  //                 )),
  //     ),
  //   );
  // }
}