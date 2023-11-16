// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/main_page.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String mazeAsset = 'assets/maze7.png';
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// main root of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Wakelock.enable;
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
