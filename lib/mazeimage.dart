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

  double _circleSize = 5;
  Offset _circlePosition = Offset(250, 350); // second one is row first is col
  // Offset? prev_pos;

  double ballMass = 0.1;
  double gravConst = 0.1;
  double xVelocity = 0.0; // the x velocity component
  double yVelocity = 0.0; // the y velocity component
  double xBallAcceleration = 0.0;
  double yBallAcceleration = 0.0;
  double xForce =
      0.0; // this is for when i decide to factor in mass into the equationx
  double yForce = 0.0;
  double elasticity = // honestly a bad name will change eventually
      2.0;

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
            bool isCollided = false;
            // print(mappedPixels[
            //     '${imgLeft.toInt() + 561},${imgTop.toInt() + 401}']); // remember is y,x not x,y (row, col) y = row, x = col
            // print('${imgLeft.toInt() + 561},${imgTop.toInt() + 401}');
            xForce = gravConst * sin(xInclination) * ballMass;
            yForce = gravConst * cos(yInclination) * ballMass;

            xBallAcceleration = xForce / ballMass;
            yBallAcceleration = yForce / ballMass;

            xVelocity = xVelocity + xBallAcceleration;
            yVelocity = yVelocity + yBallAcceleration;

            Offset _newPosition = Offset(
                (_circlePosition!.dx + (xVelocity + (0.5 * xBallAcceleration)))
                    .toInt()
                    .toDouble(),
                (_circlePosition!.dy + (yVelocity + (0.5 * yBallAcceleration)))
                    .toInt()
                    .toDouble());
            Offset pointOfInterest = Offset(
                (_circlePosition.dx + _circleSize / 2) +
                    ((_circleSize / 2) * xInclination),
                (_circlePosition.dy + _circleSize / 2) +
                    ((_circleSize / 2) * yInclination));
            // the only issue with this is that it does it from the radius instead.

            if (intersectsWall(
                pointOfInterest.dx.toInt(),
                pointOfInterest.dy.toInt(),
                _newPosition.dx.toInt(),
                _newPosition.dy.toInt(),
                mappedPixels)) {
              isCollided = true;
              // this means our destination and poi has intersected.

              // so what do we do when it intersects?

              // we need to redraw the ball in the valid location
              // how do we do this? we need to reposition the ball in the opposite position from the
              // inclinations that we caused it to hit
              // then using the top left we need to calculate the valid offset
              // this is all based on the assumption we're looking at the radius.

              // if it is in a corner we can just take the length of the diagonal which is
              // circlesize * root(2) and subtract it with the diameter of the circle

              // we will want to offset it by how much?
              //offset it by the point of interest - specifically the area in which uses the circlesize

              _newPosition = whereIntersect(
                  pointOfInterest.dx.toInt(),
                  pointOfInterest.dy.toInt(),
                  _newPosition.dx.toInt(),
                  _newPosition.dy.toInt(),
                  mappedPixels,
                  _circleSize
                      .toInt()); // so this finds where the point of interest intersects with the wall

              // now we must offset it by the value that was calculated in the point of interest
              _newPosition = Offset(
                  (_newPosition.dx -
                      (_circleSize / 2) +
                      ((_circleSize / 2) * xInclination)),
                  (_newPosition.dy - ((_circleSize / 2) * yInclination)));

              // we should also handle the next steps velocity and acceleration since we hit a wall here..
              // this can probably be done with xinclination and y inclination

              // xVelocity =
              //     xVelocity / 2; // cuts the velocities in half (loses energy)
              // yVelocity = yVelocity / 2;

              if (xInclination < 0) {
                //means we're going left
                xBallAcceleration = -xBallAcceleration;
                xVelocity = xVelocity / elasticity;
                xVelocity = ((xVelocity * -cos(xInclination))).toDouble();
                yBallAcceleration = 0;
                // if (isCollided) {}
              }

              if (xInclination > 0) {
                // means we're going right
                xBallAcceleration = -xBallAcceleration;
                xVelocity = xVelocity / elasticity;
                xVelocity = ((xVelocity * -cos(xInclination))).toDouble();
                yBallAcceleration = 0;
                _newPosition = Offset(
                    _circlePosition!.dx + (xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (yVelocity + yBallAcceleration));
                // if (isCollided) {}
              }

              if (yInclination < 0) {
                // means we're going up
                xBallAcceleration = 0;
                yVelocity = ((yVelocity * -sin(yInclination)).toDouble());
                yBallAcceleration = -yBallAcceleration;
                yVelocity = (yVelocity / elasticity);
                _newPosition = Offset(
                    _circlePosition!.dx + (xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (yVelocity + yBallAcceleration));
                // if (isCollided) {}
              }

              if (yInclination > 0) {
                // means we're going down
                xBallAcceleration = 0;
                yVelocity = ((yVelocity * -sin(yInclination)).toDouble());
                yBallAcceleration = -yBallAcceleration;
                yVelocity = (yVelocity / elasticity);
                _newPosition = Offset(
                    _circlePosition!.dx + (xVelocity + xBallAcceleration),
                    _circlePosition!.dy + (yVelocity + yBallAcceleration));
                // if (isCollided) {}
              }
              _circlePosition = _newPosition;
            } else {
              isCollided = false;
              _circlePosition = Offset(
                  _circlePosition!.dx + (xVelocity + (xBallAcceleration)),
                  _circlePosition!.dy + (yVelocity + (yBallAcceleration)));
            }

            // this is the next transformation where the ball wants to go next!

            // print("New Position without Offset: ${_newPosition.toString()}");

            // if (intersectsWall(
            //     _circlePosition.dx.toInt(),
            //     _circlePosition.dy.toInt(),
            //     _newPosition.dx.toInt(),
            //     _newPosition.dy.toInt(),
            //     mappedPixels)) {
            //   _newPosition = whereIntersect(
            //       _circlePosition.dx.toInt(),
            //       _circlePosition.dy.toInt(),
            //       _newPosition.dx.toInt(),
            //       _newPosition.dy.toInt(),
            //       mappedPixels,
            //       _circleSize.toInt());

            // xBallAcceleration = -xBallAcceleration;
            // yBallAcceleration = -yBallAcceleration;
            // xVelocity = xVelocity * -cos(xInclination / yInclination);
            // yVelocity = yVelocity * -sin(xInclination / yInclination);

            // xVelocity = xVelocity / 2;
            // yVelocity = yVelocity / 2;

            // if (xInclination < 0) { // this means we're going left

            // }
            // if (xInclination > 0) { // this means we're going right

            // }

            // if (yInclination < 0) { // this means we're going up

            // }

            // if (yInclination > 0) { // that means we're going down

            // }
            // }

            // _circlePosition = _newPosition;

            // example current ball position is (130,103)
            // print(intersectsWall(_circlePosition.dx.toInt(),
            //     _circlePosition.dy.toInt(), 190, 103, mappedPixels));
            // print(_circlePosition.dx.toString() +
            //     "," +
            //     _circlePosition.dy.toString());
            // print(whereIntersect(
            //     _circlePosition.dx.toInt(),
            //     _circlePosition.dy.toInt(),
            //     190,
            //     103,
            //     mappedPixels,
            //     _circleSize.toInt()));

            // // _circlePosition = Offset(192.0, 100.0);
            // _circlePosition = Offset(163.0, 103.0);

            // _circlePosition = whereIntersect(
            //     _circlePosition.dx.toInt(),
            //     _circlePosition.dy.toInt(),
            //     (_circlePosition!.dx + (xVelocity + (0.5 * xBallAcceleration)))
            //         .toInt(),
            //     (_circlePosition!.dy + (yVelocity + (0.5 * yBallAcceleration)))
            //         .toInt(),
            //     mappedPixels,
            //     _circleSize.toInt());

            // print(xVelocity);
            // print(yVelocity);

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
