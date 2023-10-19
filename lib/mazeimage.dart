import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class mazeImage extends StatefulWidget {
  const mazeImage({Key? key}) : super(key: key);
  @override
  _mazeImageState createState() => _mazeImageState();
}

Future<ui.Image> loadAssetImage(String imagePath) async {
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

Future<void> loadAndConvertImage() async {
  final imagePath = "assets/maze1.png"; // Replace with your image asset path
  final bitmapImage = await convertImageToBitmap(imagePath);

  // Now you have the image in bitmap format, and you can use it as needed.
}

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

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final imagePath =
//       'assets/your_image.png'; // Replace with your image asset path
//   final pixelArray = await convertBitmapTo2DArray(imagePath);

//   if (pixelArray != null) {
//     // You now have a 2D array of pixel values.
//     print(pixelArray);
//   }
// }

class _mazeImageState extends State<mazeImage> {
  // var bitmap = loadAndConvertImage();
  // var converted = await convertBitmapTo2DArray("assets/maze1.png");
  // print(converted);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/maze1.png",
    );
    // for (var pixel in context) {

    // }
  }
}

// for var pixel in
