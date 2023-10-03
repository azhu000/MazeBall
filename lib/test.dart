import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

import 'package:sensors_plus/sensors_plus.dart';

class SensorDataWidget extends StatefulWidget {
  const SensorDataWidget({Key? key}) : super(key: key);
  @override
  _SensorDataWidgetState createState() => _SensorDataWidgetState();
}

class _SensorDataWidgetState extends State<SensorDataWidget> {
  final double _circleSize = 30;
  Offset? _circlePosition;
  Offset? previous_position;
  @override
  Widget build(BuildContext context) {
    _circlePosition ??= Offset(
        (MediaQuery.of(context).size.width - _circleSize) / 2,
        (MediaQuery.of(context).size.height - _circleSize) / 2);
    return StreamBuilder<UserAccelerometerEvent>(
      stream: userAccelerometerEvents,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Loading indicator
        }

        final accelerometerData = snapshot.data!;

        return StreamBuilder<GyroscopeEvent>(
          stream: gyroscopeEvents,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(); // Loading indicator
            }

            final gyroscopeData = snapshot.data!;

            // Now you have accelerometerData and gyroscopeData to use in your UI
            // Display or process the sensor data as needed
            // For example, you can show the data in Text widgets
            if (snapshot.hasData) {
              // print("Test:" +
              //     snapshot.data!.x.toString() +
              //     snapshot.data!.y.toString());
              if ((_circlePosition!.dx +
                          (gyroscopeData.y * accelerometerData.y) <
                      33) ||
                  ((_circlePosition!.dx +
                          (gyroscopeData.y * accelerometerData.y) >
                      350))) {
                print("Out of bounds x!");
                _circlePosition = previous_position;
              } else if ((_circlePosition!.dy +
                          (gyroscopeData.x * accelerometerData.x) <
                      275) ||
                  ((_circlePosition!.dy +
                          (gyroscopeData.x * accelerometerData.x) >
                      745))) {
                print("Out of bounds y!");

                _circlePosition = Offset(
                    previous_position!.dx + (-accelerometerData.x),
                    previous_position!.dy + (-accelerometerData.y));
              } else {
                previous_position = _circlePosition;
                _circlePosition = Offset(
                    _circlePosition!.dx + (gyroscopeData.y * 5),
                    _circlePosition!.dy + (gyroscopeData.x * 5));
              }
            }

            return Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                    top: 275,
                    left: 32,
                    child: Container(
                      height: 500,
                      width: 350,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.blue)),
                    )),
                Transform.translate(
                    offset: Offset(_circlePosition!.dx, _circlePosition!.dy),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black)),
                      height: _circleSize,
                      width: _circleSize,
                    )),
                Center(
                    child: Column(
                  children: [
                    SizedBox(height: 36),
                    Text("Accelerometer Data:"),
                    Text("X: ${accelerometerData.x}"),
                    Text("Y: ${accelerometerData.y}"),
                    Text("Z: ${accelerometerData.z}"),
                    SizedBox(height: 16),
                    Text("Gyroscope Data:"),
                    Text("X: ${gyroscopeData.x}"),
                    Text("Y: ${gyroscopeData.y}"),
                    Text("Z: ${gyroscopeData.z}"),
                    SizedBox(height: 16),
                    Text("xPos: ${_circlePosition!.dx}"),
                    Text("yPos: ${_circlePosition!.dy}"),
                  ],
                )),
              ],
            );
          },
        );
      },
    );
  }
}
