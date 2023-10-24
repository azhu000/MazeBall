// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navbar.dart';
import 'package:myapp/main_page.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:image/image.dart' as img;

import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ByteData mazeFile = await rootBundle.load('assets/maze1.png');
  Uint8List uint8List = mazeFile.buffer.asUint8List();
  final img.Image? mazeImage = img.decodeImage(uint8List);

  List pixelvals = [];
  List<int> hold = [];

  if (mazeImage != null) {
    Uint8List? pixelData = mazeImage.getBytes();
    int width = mazeImage.width;
    int height = mazeImage.height;

    print('Image width: $width');
    print('Image height: $height');

    if (pixelData != null) {
      for (int i = 0; i < pixelData.length; i++) {
        hold = [];
        for (int j = 0; j < 4; j++) {
          hold.add(pixelData[j]);

          // You can process red, green, blue, and alpha values for each pixel.
        }
        pixelvals.add(hold);
        // Access individual bytes in the pixel data.
      }
    }
  }

  print(pixelvals.length);

  List values = [];
  String placeholder;

  for (int i = 0; i < mazeImage!.height; i++) {
    for (int j = 0; j < mazeImage.width; j++) {
      if (pixelvals[(i + 1) * (j + 1)][0] == 0) {
        placeholder = "Black";
        values.add(placeholder);
      } else {
        placeholder = "White";
        values.add(placeholder);
      }
    }
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// main root of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          sliderTheme: SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
      )),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

void writeLogToFile(String logMessage, String filePath) {
  File file = File(filePath);
  DateTime now = DateTime.now();
  String formattedLog = '$now: $logMessage\n';

  try {
    file.writeAsStringSync(formattedLog, mode: FileMode.append);
  } catch (e) {
    print('Failed to write log to file: $e');
  }
}
