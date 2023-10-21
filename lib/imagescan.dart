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

              print('RGBA values: $rgbaValues');
            },
            child: Text('Capture Widget'),
          ),
        ],
      ),
    ),
  );
}
