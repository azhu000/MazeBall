import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BallGyro extends StatelessWidget {
  // const BallGyro({super.key});

  double posX = 180, posY = 350;
  bool collided = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(100),
        padding: const EdgeInsets.all(100),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: StreamBuilder<GyroscopeEvent>(
            stream: SensorsPlatform.instance.gyroscopeEvents,
            builder: (context, snapshot) {
              // print("");
              if (snapshot.hasData) {
                posX = posX + (snapshot.data!.y * 15);
                posY = posY + (snapshot.data!.x * 15);
              }
              // make a simulation to see if transform is the actual bottleneck
              // use a for loop and feed it some data to see how fast the transform is
              return Transform.translate(
                offset: Offset(posX, posY),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                ),
              );

              // return Transform(
              //   transform: Matrix4.rotationX(0.7),
              //   alignment: Alignment.center,
              //   // offset: Offset(posX, posY),
              //   child: CircleAvatar(
              //     radius: 20,
              //     backgroundColor: Colors.red,
              //   ),
              // );
            }));
  }
}
