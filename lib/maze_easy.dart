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
import 'navbar.dart';

class MazeEasy extends StatefulWidget {
  const MazeEasy({Key? key}) : super(key: key);

  @override
  _MazeEasyState createState() => _MazeEasyState();
}

class _MazeEasyState extends State<MazeEasy> {
  Image myimg = Image(image: AssetImage(mazeAsset));
  int? width = Image(image: AssetImage(mazeAsset)).width?.toInt();
  int? height = Image(image: AssetImage(mazeAsset)).height?.toInt();

  double imgTop = 140;
  double imgLeft = 4;

  double _circleSize = 10;
  Offset _circlePosition = Offset(250, 350); // second one is row first is col

  double ballMass = 1.0;
  double gravConst = .5;
  double xVelocity = 0.0; // the x velocity component
  double yVelocity = 0.0; // the y velocity component
  double xBallAcceleration = 0.0;
  double yBallAcceleration = 0.0;
  double xForce =
      0.0; // this is for when i decide to factor in mass into the equationx
  double yForce = 0.0;
  double elasticity = // honestly a bad name will change eventually
      4;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccelerometerEvent>(
        stream: accelerometerEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Loading indicator if no data
          }

          final accelerometerData = snapshot.data!;

          double x = accelerometerData.x,
              y = accelerometerData.y,
              z = accelerometerData.z;
          double norm_Of_g = sqrt(accelerometerData.x * accelerometerData.x +
              accelerometerData.y * accelerometerData.y +
              accelerometerData.z * accelerometerData.z);
          x = accelerometerData.x / norm_Of_g; // normalized x
          y = accelerometerData.y / norm_Of_g; // normalized y
          z = accelerometerData.z / norm_Of_g; // normalized z

          double xInclination = -(asin(x)); // angle of x
          double yInclination = (acos(y)); // angle of y
          double zInclination = (atan(z)); // angle of z

          // compute the angle of the phone
          Offset _newPosition = Offset(0.0, 0.0);
          Offset intersected = Offset(0.0, 0.0);

          if (snapshot.hasData) {
            // bool isCollided = false;
            // print(mappedPixels[
            //     '${imgLeft.toInt() + 561},${imgTop.toInt() + 401}']); // remember is y,x not x,y (row, col) y = row, x = col
            // print('${imgLeft.toInt() + 561},${imgTop.toInt() + 401}');
            xForce = gravConst * sin(xInclination) * ballMass;
            yForce = gravConst * cos(yInclination) * ballMass;

            xBallAcceleration = xForce / ballMass;
            yBallAcceleration = yForce / ballMass;

            xVelocity = xVelocity + (0.5 * xBallAcceleration);
            yVelocity = yVelocity + (0.5 * yBallAcceleration);

            _newPosition = Offset(
                (_circlePosition!.dx + (xVelocity + (xBallAcceleration)))
                    .toInt()
                    .toDouble(),
                (_circlePosition!.dy + (yVelocity + (yBallAcceleration)))
                    .toInt()
                    .toDouble());

            Offset radius = Offset(
                _circlePosition.dx + (0.5 * _circleSize).floor(),
                _circlePosition.dy + (0.5 * _circleSize).floor());
            // find the coordinate of the radius of the ball without moving the ball

            if (intersectsWall(
                radius.dx.toInt(),
                radius.dy.toInt(),
                _newPosition.dx.toInt(),
                _newPosition.dy.toInt(),
                mappedPixels)) {
              // xBallAcceleration = 0;
              // yBallAcceleration = 0;
              xVelocity = xVelocity / elasticity;
              yVelocity = yVelocity / elasticity;
              // this means our destination and radius has intersected.
              // so what do we do when it intersects?
              // we need to redraw the ball in the valid location

              // lets have the variables that determine the direction we intersected at

              _newPosition = whereIntersect(
                  radius.dx.toInt(),
                  radius.dy.toInt(),
                  _newPosition.dx.toInt(),
                  _newPosition.dy.toInt(),
                  mappedPixels,
                  _circleSize.toInt());

              intersected = _newPosition;
              // this finds the point of intersection with the radius and the wall
              // now we must offset it by the value that was calculated for the radius

              //now that new pos has the location in which it intersects lets find out what kind of wall it is

              List<bool> pixelCheck = checkPixel(_newPosition.dx.toInt(),
                  _newPosition.dx.toInt(), mappedPixels);

              int wallTypeCheck = wallType((pixelCheck));

              if (wallTypeCheck == 0) {
                //horizontal wall
                if (cos(yInclination) > 0) {
                  //going down
                  _newPosition = Offset((_newPosition.dx),
                      (_newPosition.dy - (0.5 * _circleSize)));
                } else if (cos(yInclination) < 0) {
                  // going up
                  _newPosition = Offset((_newPosition.dx),
                      (_newPosition.dy + (0.5 * _circleSize)));
                }
              } else if (wallTypeCheck == 1) {
                //vertical wall
                if (sin(xInclination) > 0) {
                  // going right
                } else if (sin(xInclination) < 0) {
                  // going left
                }
              }

              // now that its been redrawn lets figure out where we're hit the wall lets figure out what direction we were going

              // if (wallTypeCheck == 0) {
              //   // we hit a horizontal wall
              //   xBallAcceleration = 0;
              //   yBallAcceleration = 0;
              //   yVelocity = yVelocity * -sin(yInclination);
              //   print("horizontal");
              // } else if (wallTypeCheck == 1) {
              //   yBallAcceleration = 0;
              //   xBallAcceleration = 0;
              //   yVelocity = xVelocity * -cos(xInclination);
              //   print("vertical");
              // } else {
              //   print("Error?");
              // }

              _circlePosition = _newPosition;
              // _newPosition = _circlePosition;
              // _circlePosition = Offset(
              //     _newPosition.dx + (xVelocity + (0.5 * xBallAcceleration)),
              //     _newPosition.dy + (yVelocity + (0.5 * yBallAcceleration)));
            } else {
              _circlePosition = Offset(
                  _circlePosition.dx + (xVelocity + (0.5 * xBallAcceleration)),
                  _circlePosition.dy + (yVelocity + (0.5 * yBallAcceleration)));
            }
          }

          return Stack(
            children: <Widget>[
              Scaffold(
                appBar: AppBar(
                  title: const Text('Easy'),
                  backgroundColor: Colors.deepPurple,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => HomePage()));
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MazeMedium()));
                        },
                        icon: Icon(Icons.arrow_forward_ios)),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.settings)),
              ),
              Positioned(
                top: imgTop,
                left: imgLeft,
                child: RepaintBoundary(
                  key: key,
                  child: myimg,
                ),
              ),
              Positioned(
                  left: 0,
                  top: 0,
                  child: Transform.translate(
                      offset: Offset(
                          double.parse(_circlePosition!.dx.toInt().toString()),
                          double.parse(_circlePosition!.dy.toInt().toString())),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black)),
                        height: _circleSize,
                        width: _circleSize,
                      ))),
              Positioned(
                top: imgTop - 50,
                left: imgLeft,
                child: ElevatedButton(
                  onPressed: () async {
                    List<int> rgbaValues = await captureWidgetToRGBAValues(key);
                    // Process the RGBA values here.
                    List<List<int>> vals = await rgbaArray(rgbaValues);

                    List<int> imageDimensions = await getDimensions(mazeAsset);

                    final convert = await convertPixels(
                        vals, imageDimensions[1], imageDimensions[0]);

                    final mappedPixels = await mapPixel(
                        convert,
                        imageDimensions[1],
                        imageDimensions[0],
                        imgTop,
                        imgLeft);

                    // for (var i in mappedPixels)

                    xBallAcceleration = 0;
                    yBallAcceleration = 0;
                    xVelocity = 0;
                    yVelocity = 0;

                    // print(vals.length);
                    // print(convert);
                    // print(mappedPixels);
                    // for (int i = imgLeft.toInt(); i < imageDimensions[1]; i++) {
                    //   for (int j = imgTop.toInt();
                    //       j < imageDimensions[0];
                    //       j++) {
                    //     print('$i, $j: ${mappedPixels['$i,$j']}');
                    //     if (mappedPixels['$i,$j'] == null) {
                    //       print("Found null at $i, $j");
                    //       break;
                    //     }
                    //   }
                    // }
                    // print(mappedPixels[
                    //     '10,160']); // remember is y,x not x,y (row, col) y = row, x = col

                    // print(mappedPixels
                    //     .length); // validated, the number of key,value pairs in mappedPixels is equal to WxH of the image.
                    _circlePosition = Offset(250, 350);
                    print(
                        'Image dimensions: ${imageDimensions[0]} x ${imageDimensions[1]}, # pixels equals ${imageDimensions[0] * imageDimensions[1]}');
                  },
                  child: Text('Scan Maze'),
                ),
              ),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.4),
                    Text("Ball Radius:"),
                    Text(
                        "X: ${(_circlePosition.dx + (0.5 * _circleSize)).toInt()}"),
                    Text(
                        "Y: ${(_circlePosition.dy + (0.5 * _circleSize)).toInt()}"),
                    // Text("Z: ${accelerometerData.z.toStringAsFixed(4)}"),
                  ]),
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.4),
                    Text("Pixel Collided:"),
                    Text("xPos: ${intersected!.dx.toInt().toString()}"),
                    Text("yPos: ${intersected!.dy.toInt().toString()}"),
                  ]),
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.4),
                    Text("Angle:"),
                    Text("X: ${sin(xInclination).toStringAsFixed(2)}"),
                    Text("Y: ${cos(yInclination).toStringAsFixed(2)}"),
                  ]),
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.4),
                    Text("Velocity:"),
                    Text("X: ${xVelocity.toStringAsFixed(2)}"),
                    Text("Y: ${yVelocity.toStringAsFixed(2)}"),
                  ]),
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.4),
                    Text("Acceleration:"),
                    Text("X: ${(xBallAcceleration).toStringAsFixed(2)}"),
                    Text("Y: ${(yBallAcceleration).toStringAsFixed(2)}"),
                  ])
                ],
              )),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.25),
                    Text("AccelData:"),
                    Text("X: ${accelerometerData.x.toStringAsFixed(4)}"),
                    Text("Y: ${accelerometerData.y.toStringAsFixed(4)}"),
                    Text("Z: ${accelerometerData.z.toStringAsFixed(4)}"),
                  ]),
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.25),
                    Text("BallPosition:"),
                    Text("xPos: ${_circlePosition!.dx.toInt().toString()}"),
                    Text("yPos: ${_circlePosition!.dy.toInt().toString()}"),
                  ]),
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.25),
                    Text("Angle:"),
                    Text("X: ${sin(xInclination).toStringAsFixed(2)}"),
                    Text("Y: ${cos(yInclination).toStringAsFixed(2)}"),
                  ]),
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.25),
                    Text("Velocity:"),
                    Text("X: ${xVelocity.toStringAsFixed(2)}"),
                    Text("Y: ${yVelocity.toStringAsFixed(2)}"),
                  ]),
                  Column(children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 1.25),
                    Text("Acceleration:"),
                    Text("X: ${(xBallAcceleration).toStringAsFixed(2)}"),
                    Text("Y: ${(yBallAcceleration).toStringAsFixed(2)}"),
                  ])
                ],
              )),
            ],
          );
        });
  }
}
