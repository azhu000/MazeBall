import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'imagescan.dart';
import 'conversions.dart';
import 'dart:math';

class mazeImage extends StatefulWidget {
  const mazeImage({Key? key}) : super(key: key);
  @override
  _mazeImageState createState() => _mazeImageState();
}

class _mazeImageState extends State<mazeImage> {
  Image myimg = Image(image: AssetImage(mazeAsset));
  int? width = Image(image: AssetImage(mazeAsset)).width?.toInt();
  int? height = Image(image: AssetImage(mazeAsset)).height?.toInt();

  double imgTop = 100;
  double imgLeft = 4;
  // MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width / 2;

  double _circleSize = 1;
  Offset _circlePosition = Offset(200, 50); // second one is row first is col
  // Offset? prev_pos;

  double ballMass = 0.1;
  double gravConst = 0.3;
  double xVelocity = 0.0; // the x velocity component
  double yVelocity = 0.0; // the y velocity component
  double xBallAcceleration = 0.0;
  double yBallAcceleration = 0.0;
  double xForce =
      0.0; // this is for when i decide to factor in mass into the equationx
  double yForce = 0.0;
  double elasticity = // honestly a bad name will change eventually
      1.5;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccelerometerEvent>(
        stream: accelerometerEvents,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Loading indicator if no data
          }

          final accelerometerData = snapshot.data!;
          // print(mappedPixels);

          double x = accelerometerData.x,
              y = accelerometerData.y,
              z = accelerometerData.z;
          double norm_Of_g = sqrt(accelerometerData.x * accelerometerData.x +
              accelerometerData.y * accelerometerData.y +
              accelerometerData.z * accelerometerData.z);
          x = accelerometerData.x / norm_Of_g;
          y = accelerometerData.y / norm_Of_g;
          z = accelerometerData.z / norm_Of_g;

          double xInclination = -(asin(x));
          double yInclination = (acos(y));
          double zInclination = (atan(z));

          if (snapshot.hasData) {
            // print(mappedPixels[
            //     '${imgLeft.toInt() + 561},${imgTop.toInt() + 401}']); // remember is y,x not x,y (row, col) y = row, x = col
            // print('${imgLeft.toInt() + 561},${imgTop.toInt() + 401}');
            xForce = gravConst * sin(xInclination) * ballMass;
            yForce = gravConst * cos(yInclination) * ballMass;

            xBallAcceleration = xForce / ballMass;
            yBallAcceleration = yForce / ballMass;

            xVelocity = xVelocity + xBallAcceleration;
            yVelocity = yVelocity + yBallAcceleration;

            print(intersectsWall(_circlePosition.dx.toInt(),
                _circlePosition.dy.toInt(), 190, 110, mappedPixels));
            print(_circlePosition.dx.toString() +
                "," +
                _circlePosition.dy.toString());
            print(whereIntersect(
                _circlePosition.dx.toInt(),
                _circlePosition.dy.toInt(),
                190,
                110,
                mappedPixels,
                _circleSize.toInt()));

            // _circlePosition = Offset(192.0, 100.0);

            // _circlePosition = whereIntersect(_circlePosition.dx.toInt(),
            //     _circlePosition.dy.toInt(), 190, 110, mappedPixels);

            // xForce = xBallAcceleration * ballMass;
            // yForce = yBallAcceleration * ballMass;

            // _circlePosition = intersectsWall(
            //     _circlePosition.dx.toInt(),
            //     _circlePosition.dy.toInt(),
            //     (_circlePosition!.dx + (xVelocity + (0.5 * xBallAcceleration)))
            //         .toInt(),
            //     (_circlePosition!.dy + (yVelocity + (0.5 * yBallAcceleration)))
            //         .toInt(),
            //     mappedPixels,
            //     _circlePosition);

            // if (intersectsWall(
            //   _circlePosition.dx.toInt(),
            //   _circlePosition.dy.toInt(),
            //   (_circlePosition!.dx + (xVelocity + (0.5 * xBallAcceleration)))
            //       .toInt(),
            //   (_circlePosition!.dy + (yVelocity + (0.5 * yBallAcceleration)))
            //       .toInt(),
            //   mappedPixels,
            // )) {
            //   // xBallAcceleration = 0;
            //   // yBallAcceleration = 0;
            //   // xVelocity = xVelocity * -cos(xInclination);
            //   // yVelocity = yVelocity * -sin(yInclination);
            //   _circlePosition = whereIntersect(
            //     _circlePosition.dx.toInt(),
            //     _circlePosition.dy.toInt(),
            //     (_circlePosition!.dx + (xVelocity + (0.5 * xBallAcceleration)))
            //         .toInt(),
            //     (_circlePosition!.dy + (yVelocity + (0.5 * yBallAcceleration)))
            //         .toInt(),
            //     mappedPixels,
            //   );
            // }

            // print(intersectsWall(
            //             _circlePosition.dx.toInt(),
            //             _circlePosition.dy.toInt(),
            //             (_circlePosition!.dx +
            //                     (xVelocity + (0.5 * xBallAcceleration)))
            //                 .toInt(),
            //             (_circlePosition!.dy +
            //                     (yVelocity + (0.5 * yBallAcceleration)))
            //                 .toInt(),
            //             mappedPixels,
            //             _circlePosition)
            //         .toString() +
            //     _circlePosition.toString());

            // _circlePosition = Offset(
            //     _circlePosition!.dx + (xVelocity + (0.5 * xBallAcceleration)),
            //     _circlePosition!.dy + (yVelocity + (0.5 * yBallAcceleration)));
          }

          return Stack(
            children: <Widget>[
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
                        height: 1,
                        width: 1,
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
                    _circlePosition = Offset(200, 50);
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
                    Text("X: ${(sin(xInclination)).toStringAsFixed(2)}"),
                    Text("Y: ${(cos(yInclination)).toStringAsFixed(2)}"),
                  ])
                ],
              )),
            ],
          );
        });
  }
}
