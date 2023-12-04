// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/gridViewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/maze_easy.dart';
import 'package:myapp/maze_hard.dart';
import 'package:myapp/maze_medium.dart';
import 'mazeimage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  //document IDs
  List<String> docIDs = [];

  //get docIDS;
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('user').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Home'), backgroundColor: Colors.deepPurple),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  Padding(
            //   padding: EdgeInsets.all(24.0),
            //   child: GridViewer(),
            // ),
            Text(
              'Welcome to Mazeball',
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.bebasNeue(fontSize: 50, color: Colors.deepPurple),
            ),
            SizedBox(height: 30),
            Text(
              'Choose your level to play!',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 36,
                color: Colors.black45,
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(BuildContext context) => MazeEasy()));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      '     EASY      ',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 36,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                    Icon(Icons.star, size: 32.0, color: Colors.white),
                    Icon(Icons.star, size: 32.0, color: Colors.white),
                    Icon(Icons.star, size: 32.0, color: Colors.white),
                    Icon(Icons.star, size: 32.0, color: Colors.white),
                  ]),
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(BuildContext context) => MazeMedium()));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      '   MEDIUM   ',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 36,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                    Icon(Icons.star, size: 32.0, color: Colors.white),
                    Icon(Icons.star, size: 32.0, color: Colors.white),
                  ]),
                ),
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(BuildContext context) => MazeHard()));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      '     HARD      ',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 36,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                    Icon(Icons.star, size: 32.0, color: Colors.yellow),
                  ]),
                ),
              ),
            ),

            // MaterialButton(
            //   onPressed: () {
            //     //FirebaseAuth.instance.signOut();
            //   },
            //   color: Colors.deepPurple,
            //   padding: EdgeInsets.all(10.0),
            //   child: Row(mainAxisSize: MainAxisSize.min, children: [
            //     Text(
            //       '   EASY   ',
            //       style: GoogleFonts.bebasNeue(
            //         color: Colors.white,
            //         fontSize: 36,
            //         //fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //     Icon(Icons.star, size: 36.0, color: Colors.white),
            //     Icon(Icons.star, size: 36.0, color: Colors.white),
            //     Icon(Icons.star, size: 36.0, color: Colors.white),
            //     Icon(Icons.star, size: 36.0, color: Colors.white),
            //   ]),
            // ),

            // SizedBox(height: 10),

            // MaterialButton(
            //   onPressed: () {
            //     //FirebaseAuth.instance.signOut();
            //   },
            //   color: Colors.deepPurple,
            //   padding: EdgeInsets.all(10.0),
            //   child: Row(mainAxisSize: MainAxisSize.min, children: [
            //     Text(
            //       'Medium ',
            //       style: GoogleFonts.bebasNeue(
            //         color: Colors.white,
            //         fontSize: 36,
            //         //fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //     Icon(Icons.star, size: 36.0, color: Colors.white),
            //     Icon(Icons.star, size: 36.0, color: Colors.white),
            //   ]),
            // ),

            // SizedBox(height: 10),

            // MaterialButton(
            //   onPressed: () {
            //     //FirebaseAuth.instance.signOut();
            //   },
            //   color: Colors.deepPurple,
            //   padding: EdgeInsets.all(10.0),
            //   child: Row(mainAxisSize: MainAxisSize.min, children: [
            //     Text(
            //       '   HARD   ',
            //       style: GoogleFonts.bebasNeue(
            //         color: Colors.white,
            //         fontSize: 36,
            //         //fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //     Icon(Icons.star, size: 36.0, color: Colors.yellow),
            //   ]),
            // ),

            SizedBox(height: 100),
            Text('Signed In as: ' + user.email!),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.deepPurple,
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
