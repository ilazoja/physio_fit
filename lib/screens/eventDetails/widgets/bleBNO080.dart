import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vector_math/vector_math.dart' as vector_math;

class BleBNO080 extends StatefulWidget {
  const BleBNO080({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  State<StatefulWidget> createState() => BleBNO080State();
}

class BleBNO080State extends State<BleBNO080> {
  final String serviceUUID = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  final String sensor1CharUUID = 'df67ff1a-718f-11e7-8cf7-a6006ad3dba0';
  final String sensor2CharUUID = '58f7db38-8ad9-4d58-98bd-135e3a656e59';
  bool isReady;
  Stream<List<int>> sensor1Stream;
  Stream<List<int>> sensor2Stream;

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  Future<void> connectToDevice() async {
    if (widget.device == null) {
      popToBefore();
      return;
    }

    Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        popToBefore();
      }
    });

    await widget.device.connect();
    discoverServices();
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
            sensor1Stream = characteristic.value;

            setState(() {
            isReady = true;
            });
          }
          if (characteristic.uuid.toString() == sensor2CharUUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            sensor2Stream = characteristic.value;

            setState(() {
            isReady = true;
            });
          }
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

  vector_math.Quaternion _dataParser(List<int> dataFromDevice) {
    final String quatString = utf8.decode(dataFromDevice);
    final List<String> quatList = quatString.split(',');
    final double w = roundDouble(double.tryParse(quatList[0]), 7) ?? 0;
    final double x = roundDouble(double.tryParse(quatList[1]), 7) ?? 0;
    final double y = roundDouble(double.tryParse(quatList[2]), 7) ?? 0;
    final double z = roundDouble(double.tryParse(quatList[3]), 7) ?? 0;

    return vector_math.Quaternion(x, y, z, w);
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
                ? Center(
                    child: Text(
                      "Waiting...",
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                  )
                : Container(
                    child: StreamBuilder<List<int>>(
                      stream: sensor1Stream,
                      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot1) {
                        if (snapshot1.hasError)
                          return Text('Error: ${snapshot1.error}');

                        if (snapshot1.connectionState == ConnectionState.active) {
                          final vector_math.Quaternion sensor1Values = _dataParser(snapshot1.data);

                          return Center(
                              child: Stack(
                            children: <Widget>[
                              Column(children: <Widget>[
                                const Text('Current value from Sensor',
                                    style: TextStyle(fontSize: 14)),
                                Text('${roundDouble(sensor1Values.w, 7)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text('${roundDouble(sensor1Values.x, 7)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text('${roundDouble(sensor1Values.y, 7)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text('${roundDouble(sensor1Values.z, 7)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                              ]),
                            ],
                          ));
                        } else {
                          return Text('Check the stream');
                        }
                      },
                    ),
                  )),
      ),
    );
  }
}
