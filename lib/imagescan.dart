import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

Future<List<int>> captureWidgetToRGBAValues(GlobalKey key) async {
  RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;

  // Capture the rendered image.
  ui.Image image = await boundary.toImage(pixelRatio: 1.0);

  if (image == null) {
    return [];
  }

  ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.rawRgba);

  if (byteData == null) {
    return [];
  }

  Uint8List uint8List = byteData.buffer.asUint8List();

  List<List<int>> vals = [];

  for (int i = 0; i < uint8List.length; i += 4) {
    List<int> hold = [];
    hold.add(uint8List[i]);
    hold.add(uint8List[i + 1]);
    hold.add(uint8List[i + 2]);
    hold.add(uint8List[i + 3]);
    vals.add(hold);
  }
  return uint8List;
}

GlobalKey key = GlobalKey();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Widget Capture Example'),
    ),
    body: Center(
      child: Column(
        children: <Widget>[
          RepaintBoundary(
            key: key,
            child: Container(
              width: 200.0,
              height: 200.0,
              color: Colors.red,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              List<int> rgbaValues = await captureWidgetToRGBAValues(key);
              // Process the RGBA values here.

              List<List<int>> vals = [];

              for (int i = 0; i < rgbaValues.length; i += 4) {
                List<int> hold = [];
                hold.add(rgbaValues[i]);
                hold.add(rgbaValues[i + 1]);
                hold.add(rgbaValues[i + 2]);
                hold.add(rgbaValues[i + 3]);
                vals.add(hold);
              }

              print('RGBA values: $vals');
            },
            child: Text('Capture Widget'),
          ),
        ],
      ),
    ),
  );
}
