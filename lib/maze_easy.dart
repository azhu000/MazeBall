import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:myapp/maze_medium.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'imagescan.dart';
import 'conversions.dart';
import 'home_page.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class MazeEasy extends StatefulWidget {
  const MazeEasy({Key? key}):super(key: key);

  @override
  _MazeEasyState createState() => _MazeEasyState();
}

class _MazeEasyState extends State<MazeEasy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:
          AppBar(
            title: const Text('Easy'), 
            backgroundColor: Colors.deepPurple,
            leading: IconButton(onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(BuildContext context) => HomePage()));

            }, 
            icon: Icon(Icons.arrow_back_ios)),
            actions: [IconButton(onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(BuildContext context) => MazeMedium()));

            }, 
            icon: Icon(Icons.arrow_forward_ios)),],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.deepPurple,
      child: Icon(Icons.settings) ),
    );
  }
}