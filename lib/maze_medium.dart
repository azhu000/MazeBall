import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:myapp/maze_hard.dart';
import 'package:myapp/navbar.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'imagescan.dart';
import 'home_page.dart';
import 'conversions.dart';
import 'dart:math';
import 'navbar.dart';

class MazeMedium extends StatefulWidget {
  const MazeMedium({Key? key}) : super(key: key);

  @override
  _MazeMediumState createState() => _MazeMediumState();
}

class _MazeMediumState extends State<MazeMedium> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medium'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Navbar()));
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => MazeHard()));
              },
              icon: Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }
}
