import 'package:confetti/confetti.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'imagescan.dart';
import 'conversions.dart';
import 'home_page.dart';
import 'dart:math';
import 'navbar.dart';

class MazeHard extends StatefulWidget {
  const MazeHard({Key? key}) : super(key: key);

  @override
  _MazeHardState createState() => _MazeHardState();
}

class _MazeHardState extends State<MazeHard> {
  final _controller = ConfettiController();
  bool isPlaying = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hard'),
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
                if (isPlaying) {
                  _controller.stop();
                } else {
                  _controller.play();
                }
                isPlaying = !isPlaying;
              },
              icon: Icon(Icons.emoji_emotions)),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Other widgets in the body
          // Add the ConfettiWidget here
          ConfettiWidget(
            confettiController: _controller,
            blastDirection: 0,
          ),
        ],
      ),
    );
  }
}
