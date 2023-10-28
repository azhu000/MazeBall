// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:wakelock/wakelock.dart';
// import 'dart:async';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'mazeimage.dart';
// import 'package:image/image.dart';

// String mazeAsset = 'assets/maze6.png';

// // Offset translateBall (Offset currentPos, )

// class AccelerometerStream extends StatefulWidget {
//   @override
//   _AccelerometerStreamState createState() => _AccelerometerStreamState();
// }

// class _AccelerometerStreamState extends State<AccelerometerStream> {
//   StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

//   @override
//   void initState() {
//     super.initState();

//     _accelerometerSubscription = accelerometerEvents.listen((event) {
//       // Handle accelerometer events here
//       print('Accelerometer Event: $event');
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     // Cancel the subscription when the widget is disposed
//     _accelerometerSubscription?.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var test = mazeImage();
//     // List<int> dimensions = (test.loadImage(mazeAsset)) as List;
//     return Transform.translate(
//         // offset: Offset(double.parse((dimensions[0] ~/ 2).toString()),
//         //     double.parse((dimensions[1] ~/ 2).toString())),
//         child: Container(
//           decoration: BoxDecoration(
//               color: Colors.red,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.black)),
//           height: 1,
//           width: 1,
//         ));
//   }
// }
