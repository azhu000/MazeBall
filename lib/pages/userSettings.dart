import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/gridViewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:wakelock/wakelock.dart';
import 'package:sensors_plus/sensors_plus.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);
  @override
  _userSettingsDataWidgetState createState() => _userSettingsDataWidgetState();
}

class _userSettingsDataWidgetState extends State<UserSettings> {
  final user = FirebaseAuth.instance.currentUser!;

  //document IDs
  List<String> docIDs = [];

  //get docIDS;
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('user').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  double topOffset = double.parse(
      (MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height /
              2.25)
          .toStringAsFixed(4));
  double leftOffset = double.parse(
      (MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width /
              12.5)
          .toStringAsFixed(4));
  late double widthRect = double.parse(
      (MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width -
              (2 * leftOffset))
          .toStringAsFixed(
              4)); // this is the width of the  width of the bounding rectangle

  double _circleSize = 25;
  Offset? _circlePosition;
  Offset? prev_pos;

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

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    double cellLength = sqrt((widthRect * widthRect) / 25);

    print(cellLength);

    _circlePosition ??= Offset(
        leftOffset + ((cellLength / 2) - (_circleSize / 2)),
        topOffset + ((cellLength / 2) - (_circleSize / 2)));
    // print(leftOffset);
    // print(_circlePosition!.dx + (xVelocity + xBallAcceleration));
    // print((MediaQuery.of(context).size.height - topOffset));
    return StreamBuilder<AccelerometerEvent>(
        stream: accelerometerEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Loading indicator if no data
          }

          final accelerometerData = snapshot.data!;

          double x = accelerometerData.x,
              y = accelerometerData.y,
              z = accelerometerData.z;
          double norm_Of_g = sqrt(accelerometerData.x * accelerometerData.x +
              accelerometerData.y * accelerometerData.y +
              accelerometerData.z * accelerometerData.z);
          x = accelerometerData.x / norm_Of_g;
          y = accelerometerData.y / norm_Of_g;
          z = accelerometerData.z / norm_Of_g;

          // double xInclination = -(asin(x) * (180 / pi));
          // double yInclination = (acos(y) * (180 / pi));
          // double zInclination = (atan(z) * (180 / pi));

          double xInclination = -(asin(x));
          double yInclination = (acos(y));
          double zInclination = (atan(z));

          return StreamBuilder<GyroscopeEvent>(
            stream: gyroscopeEvents,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(); // Loading indicator if no data
              }

              final gyroscopeData = snapshot.data!;

              // After this there is access to both accelerometer data and gyroscope data.

              if (snapshot.hasData) {
                // oh boy here we go its the start of generalizing ball movements...

                // remember wallcoords[xCoord, yCoord, height, width]

                /// ### top left corner
                if ((_circlePosition!.dx + (xVelocity + xBallAcceleration) <
                        leftOffset) &&
                    (_circlePosition!.dy + (yVelocity + yBallAcceleration) <
                        topOffset)) {
                  print("Uhoh TOP LEFT!");
                  xVelocity = xVelocity * -cos(pi / 4);
                  yVelocity = yVelocity * -sin(pi / 4);
                  xBallAcceleration = -xBallAcceleration;
                  yBallAcceleration = -yBallAcceleration;

                  _circlePosition = Offset(
                      _circlePosition!.dx + (xVelocity + xBallAcceleration),
                      _circlePosition!.dy + (yVelocity + yBallAcceleration));
                }

                /// ### top right corner border
                else if ((_circlePosition!.dx +
                            (xVelocity + xBallAcceleration) >
                        leftOffset + widthRect - _circleSize) &&
                    (_circlePosition!.dy + (yVelocity + yBallAcceleration) <
                        topOffset)) {
                  print("Uhoh! TOP RIGHT");
                  xVelocity = xVelocity * -cos(pi / 4);
                  yVelocity = yVelocity * -sin(pi / 4);
                  xBallAcceleration = -xBallAcceleration;
                  yBallAcceleration = -yBallAcceleration;

                  _circlePosition = Offset(
                      _circlePosition!.dx + (xVelocity + xBallAcceleration),
                      _circlePosition!.dy + (yVelocity + yBallAcceleration));
                }

                /// ### bottom left corner border
                else if ((_circlePosition!.dx +
                            (xVelocity + xBallAcceleration) <
                        leftOffset) &&
                    (_circlePosition!.dy + (yVelocity + yBallAcceleration) >
                        (topOffset + widthRect - _circleSize))) {
                  print("Uhoh! BOTTOM LEFT");
                  xVelocity = xVelocity * -cos(pi / 4);
                  yVelocity = yVelocity * -sin(pi / 4);
                  xBallAcceleration = -xBallAcceleration;
                  yBallAcceleration = -yBallAcceleration;

                  _circlePosition = Offset(
                      _circlePosition!.dx + (xVelocity + xBallAcceleration),
                      _circlePosition!.dy + (yVelocity + yBallAcceleration));
                }

                /// ### bottom right corner border
                else if ((_circlePosition!.dx +
                            (xVelocity + xBallAcceleration) >
                        leftOffset + widthRect - _circleSize) &&
                    (_circlePosition!.dy + (yVelocity + yBallAcceleration) >
                        (topOffset + widthRect - _circleSize))) {
                  print("Uhoh! BOTTOM RIGHT");
                  xVelocity = xVelocity * -cos(pi / 4);
                  yVelocity = yVelocity * -sin(pi / 4);
                  xBallAcceleration = -xBallAcceleration;
                  yBallAcceleration = -yBallAcceleration;

                  _circlePosition = Offset(
                      _circlePosition!.dx + (xVelocity + xBallAcceleration),
                      _circlePosition!.dy + (yVelocity + yBallAcceleration));
                }

                /// ### now to handle the cases where ball is only touching one wall
                else if ((_circlePosition!.dx +
                            (xVelocity + xBallAcceleration) <
                        leftOffset) ||
                    ((_circlePosition!.dx + (xVelocity + xBallAcceleration) >
                        (leftOffset + widthRect - _circleSize)))) {
                  print("Out of bounds x!");
                  xForce = gravConst * sin(xInclination) * ballMass;
                  yForce = gravConst * cos(yInclination) * ballMass;

                  xBallAcceleration = xForce / ballMass;
                  yBallAcceleration = yForce / ballMass;

                  xVelocity = xVelocity + xBallAcceleration;
                  yVelocity = yVelocity + yBallAcceleration;
                  xBallAcceleration = -xBallAcceleration;
                  yBallAcceleration = 0;
                  xVelocity = xVelocity / elasticity;
                  xVelocity = xVelocity * -cos(xInclination);
                  _circlePosition = Offset(
                      _circlePosition!.dx + (xVelocity + xBallAcceleration),
                      _circlePosition!.dy + (yVelocity + yBallAcceleration));
                } else if ((_circlePosition!.dy +
                            (yVelocity + yBallAcceleration) <
                        topOffset) ||
                    ((_circlePosition!.dy + (yVelocity + yBallAcceleration) >
                        (topOffset + widthRect - _circleSize)))) {
                  print("Out of bounds y!");
                  xForce = gravConst * sin(xInclination) * ballMass;
                  yForce = gravConst * cos(yInclination) * ballMass;

                  xBallAcceleration = xForce / ballMass;
                  yBallAcceleration = yForce / ballMass;

                  xVelocity = xVelocity + xBallAcceleration;
                  yVelocity = yVelocity + yBallAcceleration;
                  xBallAcceleration = 0;
                  yBallAcceleration = -yBallAcceleration;
                  yVelocity = (yVelocity / elasticity);
                  yVelocity = yVelocity * -sin(yInclination);
                  _circlePosition = Offset(
                      _circlePosition!.dx + (xVelocity + xBallAcceleration),
                      _circlePosition!.dy + (yVelocity + yBallAcceleration));
                } else {
                  xForce = gravConst * sin(xInclination) * ballMass;
                  yForce = gravConst * cos(yInclination) * ballMass;

                  xBallAcceleration = xForce / ballMass;
                  yBallAcceleration = yForce / ballMass;

                  xVelocity = xVelocity + xBallAcceleration;
                  yVelocity = yVelocity + yBallAcceleration;

                  // // xForce = xBallAcceleration * ballMass;
                  // // yForce = yBallAcceleration * ballMass;

                  _circlePosition = Offset(
                      _circlePosition!.dx + (xVelocity + (xBallAcceleration)),
                      _circlePosition!.dy + (yVelocity + (yBallAcceleration)));

                  // xVelocity = xVelocity + xForce;
                  // yVelocity = yVelocity + yForce;
                }
              }

              return Scaffold(
                appBar: AppBar(
                    title: const Text('User Setting'),
                    backgroundColor: Colors.deepPurple),
                body: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Column(children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 15),
                              Text(
                                'Set your game as your taste',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.bebasNeue(
                                    fontSize: 36, color: Colors.deepPurple),
                              ),
                              SizedBox(height: 30),
                              Card(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Column(children: [
                                      Text("Ball Size"),
                                      Slider(
                                          value: _circleSize,
                                          label:
                                              "${_circleSize.toStringAsFixed(3)}",
                                          min: .1 * cellLength,
                                          max: .75 * cellLength,
                                          // divisions: 11,
                                          onChanged: (double value) {
                                            setState(() {
                                              _circleSize = value;
                                              xVelocity = 0;
                                              yVelocity = 0;
                                              xBallAcceleration = 0;
                                              yBallAcceleration = 0;
                                              _circlePosition = Offset(
                                                  leftOffset +
                                                      ((cellLength / 2) -
                                                          (_circleSize / 2)),
                                                  topOffset +
                                                      ((cellLength / 2) -
                                                          (_circleSize / 2)));
                                            });
                                          }),
                                      SizedBox(height: 20),
                                      Text("Ball Mass"),
                                      Slider(
                                          value: ballMass,
                                          label:
                                              "${ballMass.toStringAsFixed(3)}",
                                          min: .1,
                                          max: 5,
                                          // divisions: 11,
                                          onChanged: (double value) {
                                            setState(() {
                                              ballMass = value;
                                              xVelocity = 0;
                                              yVelocity = 0;
                                              xBallAcceleration = 0;
                                              yBallAcceleration = 0;
                                              _circlePosition = Offset(
                                                  leftOffset +
                                                      ((cellLength / 2) -
                                                          (_circleSize / 2)),
                                                  topOffset +
                                                      ((cellLength / 2) -
                                                          (_circleSize / 2)));
                                            });
                                          }),
                                      SizedBox(height: 20),
                                      Text("Gravity"),
                                      Slider(
                                          value: gravConst,
                                          label:
                                              "${(gravConst * 10).toStringAsFixed(3)}",
                                          min: 0.01,
                                          max: 1,
                                          // divisions: 11,
                                          onChanged: (double value) {
                                            setState(() {
                                              gravConst = value;
                                              xVelocity = 0;
                                              yVelocity = 0;
                                              xBallAcceleration = 0;
                                              yBallAcceleration = 0;
                                              _circlePosition = Offset(
                                                  leftOffset +
                                                      ((cellLength / 2) -
                                                          (_circleSize / 2)),
                                                  topOffset +
                                                      ((cellLength / 2) -
                                                          (_circleSize / 2)));
                                            });
                                          }),
                                      SizedBox(height: 20),
                                      Text(
                                          "Percentage of additional energy loss on impact"),
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
                                              xVelocity = 0;
                                              yVelocity = 0;
                                              xBallAcceleration = 0;
                                              yBallAcceleration = 0;
                                              _circlePosition = Offset(
                                                  leftOffset +
                                                      ((cellLength / 2) -
                                                          (_circleSize / 2)),
                                                  topOffset +
                                                      ((cellLength / 2) -
                                                          (_circleSize / 2)));
                                            });
                                          }),
                                    ]),
                                  ),
                                ),
                              ),
                              SizedBox(height: 80),
                              Text('Signed In as: ' + user.email!),
                              MaterialButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                                color: Colors.deepPurple,
                                child: Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              );
            },
          );
        });
  }
}
