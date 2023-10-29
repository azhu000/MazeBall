import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

String mazeAsset = 'assets/maze6.png';
Map<String, int> mappedPixels = {};

Future<ui.Image> loadAssetImage(String imagePath) async {
  //loads the asset image and returns the image as a frame
  final data = await rootBundle.load(imagePath);
  final codec = await ui
      .instantiateImageCodec(Uint8List.sublistView(data.buffer.asUint8List()));
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<ui.Image> convertImageToBitmap(String imagePath) async {
  final image = await loadAssetImage(imagePath);

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()
    ..color = Colors
        .transparent; // You can specify a background color here if needed.

  canvas.drawImage(image, Offset.zero, paint);

  final picture = recorder.endRecording();
  final img = await picture.toImage(image.width, image.height);
  return img;
}

// Future<void> loadAndConvertImage() async {
//   const imagePath = "assets/maze1.png"; // Replace with your image asset path
//   final bitmapImage = await convertImageToBitmap(imagePath);

//   // Now you have the image in bitmap format, and you can use it as needed.
// }

Future<List<List<int>>?> convertBitmapTo2DArray(String imagePath) async {
  final image = await convertImageToBitmap(imagePath);
  final width = image.width;
  final height = image.height;

  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.rawRgba);

  if (byteData == null) {
    return null;
  }

  final buffer = byteData.buffer.asUint8List();

  if (buffer.length != (width * height * 4)) {
    return null; // Ensure the buffer size matches the image dimensions and RGBA format.
  }

  final List<List<int>> result = [];

  for (int y = 0; y < height; y++) {
    final List<int> row = [];
    for (int x = 0; x < width; x++) {
      final int index = (y * width + x) * 4;
      final int alpha = buffer[index];
      final int red = buffer[index + 1];
      final int green = buffer[index + 2];
      final int blue = buffer[index + 3];
      // You can convert the RGBA values to a single integer if needed.
      final pixelValue = (alpha << 24) | (red << 16) | (green << 8) | blue;
      row.add(pixelValue);
    }
    result.add(row);
  }

  return result;
}

Future<List<List<int>>> convertPixels(
    List<List<int>> pixelsInfo, int height, int width) async {
  List<int> pixels2d = [];
  for (int i = 0; i < pixelsInfo.length; i++) {
    if ((pixelsInfo[i][0] == 0) &&
        (pixelsInfo[i][1] == 0) &&
        (pixelsInfo[i][2] == 0)) {
      pixels2d.add(1);
    } else {
      pixels2d.add(0);
    }
  }
  List<List<int>> pixels2dData = [];
  for (int y = 0; y < height; y++) {
    List<int> rows = pixels2d.sublist((y * width), (y * width) + width);
    pixels2dData.add(rows);
  }

  return pixels2dData;
}

Future<Map<String, int>> mapPixel(List<List<int>> pixelData, int height,
    int width, double initialX, double initialY) async {
  // Map<String, int> pixelMap = {};
  await Future.delayed(const Duration(seconds: 1));

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      // await Future.delayed(Duration(seconds: 2));

      int pixel = pixelData[y][x];
      int offsetY = (initialY + y).toInt();
      int offsetX = (initialX + x).toInt();
      String coordinate =
          '$offsetY,$offsetX'; // acts as our coordinate for the map
      mappedPixels[coordinate] = pixel;
    }
  }
  return mappedPixels;
}

Map<String, int> removeZeros(Map<String, int> mapPixelC) {
  // Map<String, int> copy = mapPixelC;
  mapPixelC.removeWhere((key, value) => value == 0);

  return mapPixelC;
}

Future<List<List<int>>> rgbaArray(List<int> rgbaValues) async {
  List<List<int>> vals = [];

  for (int i = 0; i < rgbaValues.length; i += 4) {
    List<int> hold = [];
    hold.add(rgbaValues[i]);
    hold.add(rgbaValues[i + 1]);
    hold.add(rgbaValues[i + 2]);
    hold.add(rgbaValues[i + 3]);
    vals.add(hold);
  }
  return vals;
}

Future<List<int>> getDimensions(String filepathImage) async {
  final ByteData mazeFile = await rootBundle.load(filepathImage);
  Uint8List uint8List = mazeFile.buffer.asUint8List();
  final img.Image? mazeImage = img.decodeImage(uint8List);

  late int width;
  late int height;
  // Get the image dimensions.
  if (mazeImage != null) {
    width = mazeImage.width;
    height = mazeImage.height;
  } else {
    debugPrint('Failed to load the image.');
  }

  return [width, height];
}
