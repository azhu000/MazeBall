import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensors_plus/sensors_plus.dart';

class newBall extends StatefulWidget {
  const newBall({Key? key}) : super(key: key);

  @override
  State<newBall> createState() => _newBallState();
}

class _newBallState extends State<newBall> {
  final double _circleSize = 30;
  Offset? _circlePosition;
  double _slope = 0;

  @override
  Widget build(BuildContext context) {
    _circlePosition ??= Offset(
        (MediaQuery.of(context).size.width - _circleSize) / 2,
        (MediaQuery.of(context).size.height - _circleSize) / 2);
    return Scaffold(
        body: Stack(
      children: [
        // Text("Testing"),
        StreamBuilder<UserAccelerometerEvent>(
            stream: SensorsPlatform.instance.userAccelerometerEvents,
            builder: (context, snapshot) {
              // print("");

              if (snapshot.hasData) {
                print("Test:" +
                    snapshot.data!.x.toString() +
                    snapshot.data!.y.toString());
                _circlePosition = Offset(
                    _circlePosition!.dx + (snapshot.data!.x * 10),
                    _circlePosition!.dy + (snapshot.data!.y * 10));
                // posX = posX + (snapshot.data!.y * 15);
                // posY = posY + (snapshot.data!.x * 15);
              }
              // make a simulation to see if transform is the actual bottleneck
              // use a for loop and feed it some data to see how fast the transform is
              return Positioned(
                  left: _circlePosition!.dx,
                  top: _circlePosition!.dy,
                  // offset: Offset(_circlePosition!.dx, _circlePosition!.dy),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black)),
                    height: _circleSize,
                    width: _circleSize,
                  ));
            }),
      ],
    ));
  }
}
