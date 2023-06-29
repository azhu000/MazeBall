import 'package:flutter/material.dart';
import 'navbar.dart';

void main() {
  runApp(const MyApp());
}

/// main root of the application
class MyApp extends StatelessWidget {
  /// create the application
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      title: 'Senior Design App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Navbar(),
    );
  }
}
