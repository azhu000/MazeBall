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
  final double _circleSize = 10;
  Offset? _circlePosition;
  // Offset? previous_position;

  final double ballMass = 10.0;
  final double gravConst = 0.1;
  double xVelocity = 0.0;
  double yVelocity = 0.0;
  double xBallAcceleration = 0.0;
  double yBallAcceleration = 0.0;
  double xForce =
      0.0; // this is for when i decide to factor in mass into the equationx
  double yForce = 0.0;

  @override
  Widget build(BuildContext context) {
    double topOffset = MediaQuery.of(context).size.height / 3;
    double leftOffset = MediaQuery.of(context).size.width / 12.5;
    double widthRect = (MediaQuery.of(context).size.width -
        (2 *
            leftOffset)); // this is the width of the  width of the bounding rectangle
    double heightRect = MediaQuery.of(context).size.height /
        1.75; // this will be the length of the height of the bounding rectangle

    _circlePosition ??= Offset(leftOffset + (widthRect - _circleSize) / 2,
        topOffset + (heightRect - _circleSize) / 2);
    print(leftOffset);
    print(_circlePosition!.dx + (xVelocity + xBallAcceleration));
    print((MediaQuery.of(context).size.height - topOffset));
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

              /// ### top left corner border
              if ((_circlePosition!.dx + (xVelocity + xBallAcceleration) <
                      leftOffset) &&
                  (_circlePosition!.dy + (yVelocity + yBallAcceleration) <
                      topOffset)) {
                print("Uhoh TOP LEFT!");

                _circlePosition = Offset(
                    _circlePosition!.dx + (-xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (-yVelocity + yBallAcceleration));
              }

              /// ### top right corner border
              else if ((_circlePosition!.dx + (xVelocity + xBallAcceleration) >
                      leftOffset + widthRect - _circleSize) &&
                  (_circlePosition!.dy + (yVelocity + yBallAcceleration) <
                      topOffset)) {
                print("Uhoh! TOP RIGHT");

                _circlePosition = Offset(
                    _circlePosition!.dx - (xVelocity + xBallAcceleration),
                    _circlePosition!.dy - (yVelocity + yBallAcceleration));
              }

              /// ### bottom left corner border
              else if ((_circlePosition!.dx + (xVelocity + xBallAcceleration) <
                      leftOffset) &&
                  (_circlePosition!.dy + (yVelocity + yBallAcceleration) >
                      (topOffset + heightRect - _circleSize))) {
                print("Uhoh! BOTTOM LEFT");

                _circlePosition = Offset(
                    _circlePosition!.dx + (-xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (-yVelocity + yBallAcceleration));
              }

              /// ### bottom right corner border
              else if ((_circlePosition!.dx + (xVelocity + xBallAcceleration) >
                      leftOffset + widthRect - _circleSize) &&
                  (_circlePosition!.dy + (yVelocity + yBallAcceleration) >
                      (topOffset + heightRect - _circleSize))) {
                print("Uhoh! BOTTOM RIGHT");

                _circlePosition = Offset(
                    _circlePosition!.dx + (-xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (-yVelocity + yBallAcceleration));
              }

              /// ### now to handle the cases where ball is only touching one wall
              else if ((_circlePosition!.dx + (xVelocity + xBallAcceleration) <
                      leftOffset) ||
                  ((_circlePosition!.dx + (xVelocity + xBallAcceleration) >
                      (leftOffset + widthRect - _circleSize)))) {
                print("Out of bounds x!");
                // _circlePosition = previous_position;
                xBallAcceleration = 0;
                yBallAcceleration = 0;
                xVelocity = xVelocity / 2;
                _circlePosition = Offset(
                    _circlePosition!.dx + (-xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (yVelocity + yBallAcceleration));
              } else if ((_circlePosition!.dy +
                          (yVelocity + yBallAcceleration) <
                      topOffset) ||
                  ((_circlePosition!.dy + (yVelocity + yBallAcceleration) >
                      (topOffset + heightRect - _circleSize)))) {
                print("Out of bounds y!");
                xBallAcceleration = 0;
                yBallAcceleration = 0;
                yVelocity = yVelocity / 2;
                _circlePosition = Offset(
                    _circlePosition!.dx + (xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (-yVelocity + yBallAcceleration));

                // _circlePosition = previous_position;
              } else {
                // previous_position = _circlePosition;

                xBallAcceleration = gravConst * gyroscopeData.y;
                yBallAcceleration = gravConst * gyroscopeData.x;

                xForce = xBallAcceleration * ballMass;
                yForce = yBallAcceleration * ballMass;

                _circlePosition = Offset(
                    _circlePosition!.dx + (xVelocity + xForce),
                    _circlePosition!.dy + (yVelocity + yForce));

                xVelocity = xVelocity + xForce;
                yVelocity = yVelocity + yForce;
              }
            }

            return Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                    top: topOffset,
                    left: leftOffset,
                    child: Container(
                      height: heightRect,
                      width: widthRect,
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
