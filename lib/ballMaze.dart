import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'package:sensors_plus/sensors_plus.dart';

class ballMaze extends StatefulWidget {
  const ballMaze({Key? key}) : super(key: key);
  @override
  _ballMazeDataWidgetState createState() => _ballMazeDataWidgetState();
}

class _ballMazeDataWidgetState extends State<ballMaze> {
  double topOffset =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height /
          2.25;
  double leftOffset =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width /
          12.5;
  late double widthRect = MediaQueryData.fromWindow(
              WidgetsBinding.instance.window)
          .size
          .width -
      (2 *
          leftOffset); // this is the width of the  width of the bounding rectangle
  double heightRect = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .size
          .height /
      2.1; // this will be the length of the height of the bounding rectangle

  double _circleSize = 25;
  Offset? _circlePosition;

  double ballMass = 2.0;
  double gravConst = 0.5;
  double xVelocity = 0.0; // the x velocity component
  double yVelocity = 0.0; // the y velocity component
  double xBallAcceleration = 0.0;
  double yBallAcceleration = 0.0;
  double xForce =
      0.0; // this is for when i decide to factor in mass into the equationx
  double yForce = 0.0;
  double elasticity = // honestly a bad name will change eventually
      1.5; // this should never be below 1 (1 means kinetic energy is conserved) for now 2 is best performing

  // Widget _ballInfo(BuildContext context) {
  //   return new AlertDialog(
  //     title: const Text('Current ball information'),
  //     content: new Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[],
  //     ),
  //     actions: <Widget>[
  //       TextButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         // style: ButtonStyle( textStyle: color:( Colors.blue)),
  //         child: const Text('Close'),
  //       ),
  //     ],
  //   );
  // }

  // Widget _mazeWalls(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //         child: Column(
  //       children: [for (var i in wallCoords) Text(i.toString())],
  //     )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    double cellLength = sqrt((widthRect * heightRect) / 30);
    // print(widthRect * heightRect);
    // print(sqrt(cellLength));
    print(cellLength);

    List<List<dynamic>> wallCoords = [
      [topOffset, leftOffset, heightRect, widthRect],
      [
        topOffset + (cellLength * 0),
        leftOffset + (cellLength * 0),
        cellLength * 1,
        1.0
      ], // first two is location of first point, 3rd is the length, 4th is width (For vertical lines) , reverse 3,4 for horizontal
      [
        topOffset + (cellLength * 0),
        leftOffset + (cellLength * 1),
        cellLength * 1,
        1.0
      ],
      [
        topOffset + (cellLength * 1),
        leftOffset + (cellLength * 1),
        (cellLength * 1),
        1.0
      ],
      [
        topOffset + (cellLength * 0),
        leftOffset + (cellLength * 2),
        cellLength * 1,
        1.0
      ],
      [
        topOffset + (cellLength * 1),
        leftOffset + (cellLength * 3),
        (cellLength * 3),
        1.0
      ],
      [
        topOffset + (cellLength * 2),
        leftOffset + (cellLength * 1),
        1.0,
        cellLength * 1
      ],
      [
        topOffset + (cellLength * 3),
        leftOffset + (cellLength * 1),
        1.0,
        (cellLength * 2)
      ],
      [
        topOffset + (cellLength * 3),
        leftOffset + (cellLength * 0),
        1.0,
        cellLength * 1
      ],
      [
        topOffset + (cellLength * 3),
        leftOffset + (cellLength * 4),
        cellLength,
        1.0
      ],
      [
        topOffset + (cellLength * 5),
        leftOffset + (cellLength * 1),
        1.0,
        cellLength * 4
      ],
      [
        topOffset + (cellLength * 4),
        leftOffset + (cellLength * 0),
        1.0,
        cellLength * 1
      ],
      [
        topOffset + (cellLength * 4),
        leftOffset + (cellLength * 2),
        cellLength,
        1.0
      ],
      [
        topOffset + (cellLength * 0),
        leftOffset + (cellLength * 4),
        cellLength,
        1.0
      ],
      [
        topOffset + (cellLength * 2),
        leftOffset + (cellLength * 3),
        1.0,
        cellLength
      ],
      [
        topOffset + (cellLength * 3),
        leftOffset + (cellLength * 4),
        1.0,
        cellLength
      ],
    ];

    _circlePosition ??= Offset(
        leftOffset + ((cellLength / 2) - (_circleSize / 2)),
        topOffset + ((cellLength / 2) - (_circleSize / 2)));
    // print(leftOffset);
    // print(_circlePosition!.dx + (xVelocity + xBallAcceleration));
    // print((MediaQuery.of(context).size.height - topOffset));
    return StreamBuilder<UserAccelerometerEvent>(
      stream: userAccelerometerEvents,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Loading indicator if no data
        }

        final accelerometerData = snapshot.data!;

        return StreamBuilder<GyroscopeEvent>(
          stream: gyroscopeEvents,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(); // Loading indicator if no data
            }

            final gyroscopeData = snapshot.data!;

            // After this there is access to both accelerometer data and gyroscope data.

            if (snapshot.hasData) {
              /// ### top left corner
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
                xBallAcceleration = 0;
                yBallAcceleration = 0;
                xVelocity = xVelocity / elasticity;
                xVelocity = xVelocity * -cos(pi / 4);
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
                yVelocity = (yVelocity / elasticity);
                yVelocity = yVelocity * -sin(pi / 4);
                _circlePosition = Offset(
                    _circlePosition!.dx + (xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (-yVelocity + yBallAcceleration));
              } else {
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
              children: [
                Center(
                  child: Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 7),
                    Text("Ball Size"),
                    Slider(
                        value: _circleSize,
                        label: "${_circleSize.toStringAsFixed(3)}",
                        min: .1 * cellLength,
                        max: .75 * cellLength,
                        // divisions: 11,
                        onChanged: (double value) {
                          setState(() {
                            _circleSize = value;
                            _circlePosition = Offset(
                                leftOffset +
                                    ((cellLength / 2) - (_circleSize / 2)),
                                topOffset +
                                    ((cellLength / 2) - (_circleSize / 2)));
                          });
                        }),
                    Text("Ball Mass"),
                    Slider(
                        value: ballMass,
                        label: "${ballMass.toStringAsFixed(3)}",
                        min: .1,
                        max: 5,
                        // divisions: 11,
                        onChanged: (double value) {
                          setState(() {
                            ballMass = value;
                            _circlePosition = Offset(
                                leftOffset +
                                    ((cellLength / 2) - (_circleSize / 2)),
                                topOffset +
                                    ((cellLength / 2) - (_circleSize / 2)));
                          });
                        }),
                    Text("Gravity"),
                    Slider(
                        value: gravConst,
                        label: "${(gravConst * 10).toStringAsFixed(3)}",
                        min: 0.01,
                        max: 1,
                        // divisions: 11,
                        onChanged: (double value) {
                          setState(() {
                            gravConst = value;
                            _circlePosition = Offset(
                                leftOffset +
                                    ((cellLength / 2) - (_circleSize / 2)),
                                topOffset +
                                    ((cellLength / 2) - (_circleSize / 2)));
                          });
                        }),
                    Text("Percentage of additional energy loss on impact"),
                    Slider(
                        value: elasticity,
                        label:
                            "${((1 - (1 / elasticity)) * 100).toStringAsFixed(2)}%",
                        min: 1,
                        max: 8,
                        // divisions: 6,
                        onChanged: (double value) {
                          setState(() {
                            elasticity = value;
                            _circlePosition = Offset(
                                leftOffset +
                                    ((cellLength / 2) - (_circleSize / 2)),
                                topOffset +
                                    ((cellLength / 2) - (_circleSize / 2)));
                          });
                        })
                  ]),
                ),
                for (var i in wallCoords)
                  Positioned(
                      top: i[0],
                      left: i[1],
                      child: Container(
                        height: i[2],
                        width: i[3],
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.blue)),
                      )),
                // Positioned( //not ncessary since loop will iterate over wallCoords
                //     top: topOffset,
                //     left: leftOffset,
                //     child: Container(
                //       height: heightRect,
                //       width: widthRect,
                //       decoration: BoxDecoration(
                //           shape: BoxShape.rectangle,
                //           border: Border.all(color: Colors.blue)),
                //     )),
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
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 29),
                      Text("AccelData:"),
                      Text("X: ${accelerometerData.x.toStringAsFixed(4)}"),
                      Text("Y: ${accelerometerData.y.toStringAsFixed(4)}"),
                      Text("Z: ${accelerometerData.z.toStringAsFixed(4)}"),
                    ]),
                    Column(children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 29),
                      Text("GyroData:"),
                      Text("X: ${gyroscopeData.x.toStringAsFixed(4)}"),
                      Text("Y: ${gyroscopeData.y.toStringAsFixed(4)}"),
                      Text("Z: ${gyroscopeData.z.toStringAsFixed(4)}"),
                    ]),
                    Column(children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 29),
                      Text("BallPosition:"),
                      Text("xPos: ${_circlePosition!.dx.toStringAsFixed(4)}"),
                      Text("yPos: ${_circlePosition!.dy.toStringAsFixed(4)}"),
                    ])
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
