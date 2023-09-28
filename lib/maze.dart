// import 'package:flutter/material.dart';
// import 'package:maze_builder/maze_builder.dart';
// import 'dart:math';
// import 'dart:ui' as ui;


// class MazeApp extends StatelessWidget {
//   void generateMaze() {
//     int size = 24;
//     Random rand = Random();
//     //final stopwatch = Stopwatch()..start();
//     List<List<Cell>> localMaze = generate(
//         width: size, height: size, closed: true, seed: rand.nextInt(100000));

//     // setState(() {
//     //   maze = localMaze;
//     //   //mazeSolution = solution;
//     // });
//   }

//   void randomize() {
//     generateMaze();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//         backgroundColor: const ui.Color.fromARGB(255, 0, 0, 0),
//         bottomNavigationBar: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50.0),
//                   color: const ui.Color.fromARGB(255, 0, 0, 0)),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: const <Widget>[],
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//         body: LayoutBuilder(builder:
//             (BuildContext context, BoxConstraints viewportConstraints) {
//           // this.viewportConstraints = viewportConstraints;
//           return Stack(children: [
//             Transform.translate(
//               offset: const Offset(50, 100),
//               child: RepaintBoundary(
//                   child: CustomPaint(
//                 size: const ui.Size(200, 400),
//                 key: UniqueKey(),
//                 isComplex: true,
//                 painter: MazeDriverCanvas(
//                   controller: _controller,
//                   maze: maze,
//                   blockSize: 16,

//                   //solution: this.mazeSolution,
//                   width: viewportConstraints.maxWidth,
//                   height: viewportConstraints.maxHeight,
//                 ),
//                 child: Container(
//                     constraints: BoxConstraints(
//                         maxWidth: viewportConstraints.maxWidth,
//                         maxHeight: viewportConstraints.maxHeight)),
//               )),
//             ),
//             Positioned(
//               top: viewportConstraints.maxHeight - 100,
//               left: viewportConstraints.maxWidth - 100,
//               child: FloatingActionButton(
//                 onPressed: randomize,
//                 backgroundColor: Colors.green,
//                 child: const Icon(Icons.refresh),
//               ),
//             ),
//           ]);

//           //);
//         }));
//   }
// }
