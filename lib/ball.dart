import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BallGyro extends StatelessWidget {
  // const BallGyro({super.key});

  double posX = 180, posY = 350;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GyroscopeEvent>(
        stream: SensorsPlatform.instance.gyroscopeEvents,
        builder: (context, snapshot) {
          // print("");
          if (snapshot.hasData) {
            posX = posX + (snapshot.data!.y * 10);
            posY = posY + (snapshot.data!.x * 10);
          }
          return Transform.translate(
            offset: Offset(posX, posY),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
            ),
          );
        });
  }
}
